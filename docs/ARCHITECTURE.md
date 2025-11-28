# Architecture Overview

## Application Structure

Tomery is a Ruby on Rails 8.1 application following modern Rails conventions with some additional patterns for maintainability and scalability.

## Core Components

### Authentication Layer

```
┌─────────────────────────────────────────────────────────┐
│                    Authentication                        │
├─────────────────────────────────────────────────────────┤
│  Devise                                                  │
│  ├── Database Authentication (email/password)           │
│  └── OmniAuth                                           │
│      └── Google OAuth2                                  │
└─────────────────────────────────────────────────────────┘
```

- **Devise**: Handles user registration, login, password recovery
- **OmniAuth**: Provides OAuth integration for third-party auth
- **Google OAuth2**: Primary social login provider

### Data Layer

```
┌─────────────────────────────────────────────────────────┐
│                    PostgreSQL                            │
├─────────────────────────────────────────────────────────┤
│  pgvector Extension                                      │
│  ├── Vector embeddings storage                          │
│  └── Similarity search (cosine, L2, inner product)      │
├─────────────────────────────────────────────────────────┤
│  Solid Trifecta (Rails 8)                               │
│  ├── Solid Cache (caching)                              │
│  ├── Solid Queue (background jobs)                      │
│  └── Solid Cable (WebSockets)                           │
└─────────────────────────────────────────────────────────┘
```

### AI/LLM Integration

```
┌─────────────────────────────────────────────────────────┐
│                    RubyLLM                               │
├─────────────────────────────────────────────────────────┤
│  Providers:                                              │
│  ├── OpenAI (GPT-4, GPT-3.5)                           │
│  ├── Anthropic (Claude)                                 │
│  └── Google (Gemini)                                    │
├─────────────────────────────────────────────────────────┤
│  Features:                                               │
│  ├── Chat completions                                   │
│  ├── Embeddings generation                              │
│  └── Function calling                                   │
└─────────────────────────────────────────────────────────┘
```

### Frontend Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend Stack                        │
├─────────────────────────────────────────────────────────┤
│  Hotwire                                                 │
│  ├── Turbo (SPA-like navigation)                        │
│  │   ├── Turbo Drive (page navigation)                  │
│  │   ├── Turbo Frames (partial updates)                 │
│  │   └── Turbo Streams (real-time updates)              │
│  └── Stimulus (JS controllers)                          │
├─────────────────────────────────────────────────────────┤
│  Styling                                                 │
│  ├── Tailwind CSS 4                                     │
│  └── RubyUI (component library)                         │
└─────────────────────────────────────────────────────────┘
```

## Design Patterns

### Service Objects

Use service objects for complex business logic that doesn't belong in models or controllers:

```ruby
# app/services/user_onboarding_service.rb
class UserOnboardingService
  def initialize(user)
    @user = user
  end

  def call
    # Complex onboarding logic
  end
end
```

### Query Objects

For complex database queries:

```ruby
# app/queries/active_users_query.rb
class ActiveUsersQuery
  def initialize(scope = User.all)
    @scope = scope
  end

  def call
    @scope.where(active: true).where("last_login_at > ?", 30.days.ago)
  end
end
```

### Presenters/View Objects

For complex view logic:

```ruby
# app/presenters/user_presenter.rb
class UserPresenter
  def initialize(user)
    @user = user
  end

  def display_name
    @user.name.presence || @user.email.split("@").first
  end
end
```

## Directory Structure

```
tomery/
├── app/
│   ├── components/          # Phlex/RubyUI components
│   │   ├── base.rb
│   │   └── ruby_ui/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── home_controller.rb
│   │   └── users/
│   │       └── omniauth_callbacks_controller.rb
│   ├── helpers/
│   ├── jobs/
│   ├── mailers/
│   ├── models/
│   │   ├── application_record.rb
│   │   └── user.rb
│   ├── presenters/          # View presenters (create as needed)
│   ├── queries/             # Query objects (create as needed)
│   ├── services/            # Service objects (create as needed)
│   └── views/
├── config/
│   ├── initializers/
│   │   ├── devise.rb
│   │   ├── ruby_llm.rb
│   │   └── ruby_ui.rb
│   └── deploy.yml           # Kamal deployment config
├── db/
│   └── migrate/
├── docs/                    # Documentation
├── spec/                    # RSpec tests
│   ├── factories/
│   ├── models/
│   ├── requests/
│   └── support/
└── .github/
    └── workflows/
        └── ci.yml           # GitHub Actions CI
```

## Request Flow

```
1. Request arrives
   │
2. Rack middleware (CSRF, sessions, etc.)
   │
3. Rails router (config/routes.rb)
   │
4. Controller
   │  ├── Authentication (Devise)
   │  ├── Authorization (if implemented)
   │  └── Action
   │
5. Service/Model layer
   │  ├── Business logic (services)
   │  ├── Data access (models)
   │  └── External APIs (RubyLLM, etc.)
   │
6. Response
   ├── HTML (ERB/Phlex + Turbo)
   ├── JSON (API responses)
   └── Turbo Stream (real-time updates)
```

## Deployment

Deployed using Kamal (Docker-based deployment):

```
┌─────────────────────────────────────────────────────────┐
│                    Production                            │
├─────────────────────────────────────────────────────────┤
│  Thruster (HTTP proxy)                                   │
│  └── Puma (Rails app server)                            │
│      └── Rails Application                               │
├─────────────────────────────────────────────────────────┤
│  PostgreSQL (with pgvector)                              │
├─────────────────────────────────────────────────────────┤
│  Redis (optional, for ActionCable scaling)               │
└─────────────────────────────────────────────────────────┘
```

## Security Considerations

1. **Authentication**: Devise handles secure password storage (bcrypt)
2. **CSRF Protection**: Built-in Rails CSRF tokens
3. **SQL Injection**: ActiveRecord parameterized queries
4. **XSS Prevention**: Rails auto-escaping in views
5. **Secrets**: Rails encrypted credentials
6. **Security Scanning**: Brakeman + bundler-audit in CI

