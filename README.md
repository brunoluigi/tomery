# 🍅 Tomery

**Your AI-powered kitchen companion for eating better and cooking more at home.**

Tomery uses artificial intelligence to help you discover amazing recipes, build your personal cookbook, and make meal planning a breeze. Say goodbye to the daily "what's for dinner?" struggle.

## ✨ Features

- 🔍 **Smart Recipe Search** — Find recipes using natural language. Ask for "quick weeknight dinners with chicken" or "cozy soups for cold days"
- 📚 **Personal Cookbook** — Save and organize your favorite recipes in one place
- 🗓️ **Meal Planning** — Plan your week with AI-suggested meals based on your preferences
- 🛒 **Shopping Lists** — Auto-generate grocery lists from your meal plans
- 🥗 **Dietary Preferences** — Filter by diet, allergies, cuisine, and cooking time
- 🤖 **AI-Powered** — Powered by modern LLMs for intelligent recipe recommendations

## 🚀 Getting Started

### Prerequisites

- Ruby 3.4+
- PostgreSQL 15+ with pgvector extension
- Node.js (for development)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/tomery.git
cd tomery

# Install dependencies
bundle install

# Set up the database
bin/rails db:create db:migrate

# Configure your API keys
EDITOR="code --wait" bin/rails credentials:edit

# Start the development server
bin/dev
```

Visit http://localhost:3000

### Configuration

Edit Rails credentials to add your API keys:

```yaml
google:
  client_id: your_google_oauth_client_id
  client_secret: your_google_oauth_client_secret

openai:
  api_key: your_openai_api_key

# Or use Anthropic/Google Gemini
anthropic:
  api_key: your_anthropic_api_key
```

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Ruby on Rails 8.1 |
| **Database** | PostgreSQL + pgvector |
| **AI/LLM** | RubyLLM (OpenAI, Anthropic, Gemini) |
| **Vector Search** | Neighbor gem for semantic recipe search |
| **UI** | RubyUI + Tailwind CSS 4 |
| **Auth** | Devise + Google OAuth |
| **Background Jobs** | Solid Queue |
| **Deployment** | Kamal (Docker) |
| **Testing** | RSpec, FactoryBot, Shoulda Matchers |

## 🧑‍💻 Development

```bash
bin/dev              # Start development server
bin/rspec            # Run tests
bin/rubocop          # Lint code
bin/brakeman         # Security scan
```

### Project Structure

```
app/
├── components/       # RubyUI/Phlex components
├── controllers/      # Rails controllers
├── models/          # ActiveRecord models
├── services/        # Business logic (recipe search, meal planning)
└── views/           # Templates

docs/
├── ARCHITECTURE.md  # System design
├── CONVENTIONS.md   # Coding standards
└── DEVELOPMENT.md   # Dev guide
```

## 📖 Documentation

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Coding Conventions](docs/CONVENTIONS.md)
- [Development Guide](docs/DEVELOPMENT.md)

## 🤝 Contributing

Contributions are welcome! Please read our coding conventions and ensure all tests pass before submitting a PR.

```bash
# Before submitting
bin/rspec && bin/rubocop && bin/brakeman --no-pager
```

## 📄 License

This project is licensed under the MIT License.

---

<p align="center">
  <strong>Made with 🍳 for home cooks everywhere</strong>
</p>
