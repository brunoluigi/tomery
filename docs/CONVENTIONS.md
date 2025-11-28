# Coding Conventions

## Ruby Style

### General

```ruby
# frozen_string_literal: true

# Good: Use frozen string literal pragma in all files
```

### Naming

```ruby
# Classes: PascalCase
class UserAccount; end

# Methods and variables: snake_case
def calculate_total
  order_total = 0
end

# Constants: SCREAMING_SNAKE_CASE
MAX_RETRY_COUNT = 3

# Predicates: end with ?
def active?
  status == "active"
end

# Dangerous methods: end with !
def delete!
  destroy
end
```

### Methods

```ruby
# Good: Short, focused methods
def full_name
  "#{first_name} #{last_name}"
end

# Good: Use keyword arguments for clarity
def create_user(email:, name:, role: :member)
  User.create(email: email, name: name, role: role)
end

# Good: Guard clauses for early returns
def process_order(order)
  return if order.blank?
  return if order.cancelled?
  
  # Main logic
end
```

### Collections

```ruby
# Good: Use Ruby's enumerable methods
users.map(&:name)
users.select(&:active?)
users.reject(&:banned?)

# Good: Use find_each for large datasets
User.find_each do |user|
  process(user)
end
```

## Rails Conventions

### Models

```ruby
# frozen_string_literal: true

class User < ApplicationRecord
  # 1. Associations
  has_many :posts, dependent: :destroy
  belongs_to :organization

  # 2. Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 100 }

  # 3. Callbacks (use sparingly)
  after_create :send_welcome_email

  # 4. Scopes
  scope :active, -> { where(active: true) }
  scope :recent, -> { order(created_at: :desc) }

  # 5. Class methods
  def self.search(query)
    where("name ILIKE ?", "%#{query}%")
  end

  # 6. Instance methods
  def display_name
    name.presence || email.split("@").first
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end
end
```

### Controllers

```ruby
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.page(params[:page])
  end

  def show
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
```

### Service Objects

```ruby
# frozen_string_literal: true

# app/services/application_service.rb
class ApplicationService
  def self.call(...)
    new(...).call
  end
end

# app/services/create_post_service.rb
class CreatePostService < ApplicationService
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    post = @user.posts.build(@params)
    
    if post.save
      notify_followers(post)
      Result.success(post)
    else
      Result.failure(post.errors)
    end
  end

  private

  def notify_followers(post)
    NotifyFollowersJob.perform_later(post.id)
  end
end
```

## Testing Conventions

### Model Specs

```ruby
# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe "associations" do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end

  describe "#display_name" do
    context "when name is present" do
      it "returns the name" do
        user = build(:user, name: "John Doe")
        expect(user.display_name).to eq("John Doe")
      end
    end

    context "when name is blank" do
      it "returns email username" do
        user = build(:user, name: nil, email: "john@example.com")
        expect(user.display_name).to eq("john")
      end
    end
  end
end
```

### Request Specs

```ruby
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }

  describe "GET /posts" do
    it "returns a successful response" do
      sign_in user
      get posts_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /posts" do
    context "with valid params" do
      it "creates a new post" do
        sign_in user
        
        expect {
          post posts_path, params: { post: { title: "Test", body: "Content" } }
        }.to change(Post, :count).by(1)
      end
    end
  end
end
```

### Factories

```ruby
# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { Faker::Name.name }
    password { "password123" }

    trait :admin do
      role { :admin }
    end

    trait :with_posts do
      after(:create) do |user|
        create_list(:post, 3, user: user)
      end
    end
  end
end
```

## Component Conventions (RubyUI/Phlex)

```ruby
# frozen_string_literal: true

# app/components/card_component.rb
class CardComponent < Components::Base
  def initialize(title:, description: nil)
    @title = title
    @description = description
  end

  def view_template
    div(class: "bg-white rounded-lg shadow p-6") do
      h3(class: "text-lg font-semibold") { @title }
      p(class: "text-gray-600 mt-2") { @description } if @description
      yield if block_given?
    end
  end
end
```

## Git Commit Messages

Use conventional commits format:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting, missing semicolons
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding tests
- `chore`: Maintain (deps, build, etc.)

Examples:
```
feat(auth): add Google OAuth integration
fix(posts): resolve N+1 query in index
docs(readme): update installation instructions
refactor(users): extract onboarding to service object
test(models): add specs for User#display_name
chore(deps): update Rails to 8.1.1
```

## Database Conventions

### Migrations

```ruby
# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :posts, :status
    add_index :posts, [:user_id, :created_at]
  end
end
```

### Vector Columns (pgvector)

```ruby
class AddEmbeddingToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :embedding, :vector, limit: 1536
    add_index :posts, :embedding, using: :ivfflat, opclass: :vector_cosine_ops
  end
end
```

## Environment Variables & Credentials

Never commit secrets. Use Rails credentials:

```bash
# Edit credentials
EDITOR="code --wait" bin/rails credentials:edit

# Structure
google:
  client_id: xxx
  client_secret: xxx
openai:
  api_key: xxx
anthropic:
  api_key: xxx
```

Access in code:
```ruby
Rails.application.credentials.dig(:google, :client_id)
```

