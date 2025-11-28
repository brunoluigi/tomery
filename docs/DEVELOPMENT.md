# Development Guide

## Prerequisites

- Ruby 3.4+
- PostgreSQL 15+ with pgvector extension
- Node.js (for asset compilation)

## Initial Setup

### 1. Clone and Install Dependencies

```bash
git clone <repository-url>
cd tomery
bundle install
```

### 2. Database Setup

Ensure PostgreSQL is running and pgvector extension is available:

```bash
# macOS with Homebrew
brew install postgresql@16 pgvector

# Enable pgvector in PostgreSQL
psql -d postgres -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

Create and migrate the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

### 3. Configure Credentials

Edit Rails credentials to add API keys:

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

Add the following structure:

```yaml
google:
  client_id: your_google_client_id
  client_secret: your_google_client_secret

openai:
  api_key: your_openai_api_key

anthropic:
  api_key: your_anthropic_api_key
```

### 4. Start the Development Server

```bash
bin/dev
```

This starts:
- Rails server (port 3000)
- Tailwind CSS watcher

Visit http://localhost:3000

## Development Workflow

### Running Tests

```bash
# All tests
bin/rspec

# Specific file
bin/rspec spec/models/user_spec.rb

# With coverage
COVERAGE=true bin/rspec
```

### Code Quality

```bash
# Rubocop
bin/rubocop

# Auto-fix
bin/rubocop -a

# Security scan
bin/brakeman

# Dependency audit
bin/bundler-audit
```

### Database Tasks

```bash
# Run migrations
bin/rails db:migrate

# Rollback
bin/rails db:rollback

# Reset database
bin/rails db:reset

# Seed data
bin/rails db:seed
```

### Rails Console

```bash
# Standard console
bin/rails console

# Sandbox mode (changes rolled back)
bin/rails console --sandbox
```

### Generating Code

```bash
# Model
bin/rails generate model Post title:string body:text user:references

# Controller
bin/rails generate controller Posts index show new create

# Migration
bin/rails generate migration AddStatusToPosts status:integer

# Service (manual creation in app/services/)
```

## Working with pgvector

### Adding Vector Columns

```ruby
# Migration
class AddEmbeddingToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :embedding, :vector, limit: 1536
  end
end
```

### Using Neighbor Gem

```ruby
class Post < ApplicationRecord
  has_neighbors :embedding
end

# Find similar posts
post.nearest_neighbors(:embedding, distance: "cosine").first(5)
```

### Generating Embeddings with RubyLLM

```ruby
response = RubyLLM.embed("Your text here")
post.update(embedding: response.embedding)
```

## Working with RubyLLM

### Chat Completion

```ruby
chat = RubyLLM.chat(model: "gpt-4o-mini")
response = chat.ask("What is Ruby on Rails?")
puts response.content
```

### With Streaming

```ruby
chat.ask("Explain Ruby") do |chunk|
  print chunk.content
end
```

### Function Calling

```ruby
chat = RubyLLM.chat
chat.with_tool(WeatherTool)
response = chat.ask("What's the weather in Tokyo?")
```

## Working with RubyUI Components

### Using Components in Views

```erb
<%= render CardComponent.new(title: "Hello", description: "World") %>
```

### Creating New Components

```ruby
# app/components/my_component.rb
class MyComponent < Components::Base
  def initialize(title:)
    @title = title
  end

  def view_template
    div(class: "p-4 bg-white rounded") do
      h2 { @title }
      yield if block_given?
    end
  end
end
```

## Debugging

### Rails Logger

```ruby
Rails.logger.debug "Debug message"
Rails.logger.info "Info message"
Rails.logger.error "Error message"
```

### Debug Gem

```ruby
# Add breakpoint
debugger

# In console, use:
# n - next line
# s - step into
# c - continue
# p variable - print variable
```

### View Debug Output

```erb
<%= debug @user %>
```

## Deployment

### Kamal Setup

1. Configure `config/deploy.yml`
2. Set up secrets in `.kamal/secrets`
3. Deploy:

```bash
bin/kamal setup    # First time
bin/kamal deploy   # Subsequent deploys
```

### Environment Variables for Production

Required environment variables:
- `DATABASE_URL` - PostgreSQL connection string
- `RAILS_MASTER_KEY` - For decrypting credentials
- `SECRET_KEY_BASE` - Rails secret key

## Troubleshooting

### Database Issues

```bash
# Reset and recreate
bin/rails db:drop db:create db:migrate

# Check pending migrations
bin/rails db:migrate:status
```

### Asset Issues

```bash
# Clear compiled assets
bin/rails assets:clobber

# Rebuild Tailwind
bin/rails tailwindcss:build
```

### Bundle Issues

```bash
# Clean and reinstall
bundle clean --force
bundle install
```

