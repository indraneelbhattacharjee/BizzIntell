# BizzIntell - AI-Powered Vendor Intelligence Platform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=flat&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-20232A?style=flat&logo=react&logoColor=61DAFB)](https://reactjs.org/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)](https://supabase.com/)

## Overview

**BizzIntell** is a comprehensive AI-powered vendor intelligence platform that automates the discovery, enrichment, and executive contact management for B2B software vendors. The platform addresses critical pain points in enterprise procurement, sales intelligence, and market research.

### Key Features

- 🤖 **AI-Powered Vendor Discovery**: Automated vendor finding using SerpAPI and custom AI filtering
- 📊 **Comprehensive Data Enrichment**: 22+ data points per vendor using Google Gemini AI
- 👥 **Executive Contact Intelligence**: Direct access to C-level decision makers via SignalHire
- 🔄 **Real-time Automation**: Continuous vendor discovery and enrichment via cron jobs
- 📈 **Market Intelligence**: Industry analysis and competitive intelligence gathering
- 🚀 **Scalable Architecture**: Microservices with Supabase Edge Functions

### Technology Stack

- **Frontend**: React 18 + TypeScript + Vite + Tailwind CSS
- **Backend**: Supabase (PostgreSQL + Edge Functions)
- **AI/ML**: Google Gemini AI for content analysis
- **APIs**: SerpAPI, SignalHire, Custom AI models
- **Deployment**: Nginx + PM2 + Docker support

## Quick Start

### Prerequisites

- Node.js 18+
- npm or yarn
- Supabase account
- API keys for SerpAPI and SignalHire

### Installation

```bash
# Clone the repository
git clone https://github.com/indraneelbhattacharjee/BizzIntell.git
cd BizzIntell

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your API keys

# Start development server
npm run dev
```

### Environment Variables

```bash
# Supabase Configuration
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

# API Keys
VITE_SERP_API_KEY=your_serp_api_key
VITE_SIGNALHIRE_API_KEY=your_signalhire_api_key
```

## Documentation

### 📋 [Project Valuation & Business Analysis](PROJECT_VALUATION_README.md)
Comprehensive business analysis including:
- Market size validation ($10B-$30B TAM)
- Revenue projections and valuation multiples
- Growth potential and competitive advantages
- Investment thesis and strategic recommendations

### 🚀 [Deployment Guide](DEPLOYMENT_README.md)
Complete deployment instructions for:
- Linux server setup and requirements
- Production deployment with Nginx + PM2
- Docker containerization
- SSL certificate configuration
- Monitoring and maintenance

### 🤖 [AI Discovery Setup](AI_DISCOVERY_SETUP.md)
AI-powered vendor discovery system:
- Automated vendor finding
- Bulk discovery jobs
- Real-time processing
- Database schema and functions

### 📊 [Comprehensive Enrichment System](COMPREHENSIVE_ENRICHMENT_SETUP.md)
Advanced vendor data enrichment:
- 22+ data points per vendor
- AI-powered content analysis
- Executive contact enrichment
- Automated cron jobs

## Market Position

### Current Stage
- **Production Stage** with $2M ARR
- **2,000+ customers** actively using the platform
- **Valuation**: $24M-$36M (12-18x ARR multiple)

### Market Opportunity
- **$10B-$30B** total addressable market
- **10-18% CAGR** across segments
- **Underserved segments** in vendor intelligence

### Growth Projections
- **2025**: $6M ARR (200% growth)
- **2026**: $15M ARR (150% growth)
- **2027**: $25M ARR (67% growth)

## Architecture

```
BizzIntell/
├── src/                    # React frontend
│   ├── components/         # UI components
│   ├── pages/             # Application pages
│   ├── context/           # React context
│   └── lib/               # Utilities
├── supabase/              # Backend functions
│   ├── functions/         # Edge functions
│   └── migrations/        # Database migrations
├── docs/                  # Documentation
└── scripts/               # Automation scripts
```

## API Endpoints

### Vendor Discovery
- `POST /api/discovery/create-job` - Create discovery job
- `GET /api/discovery/jobs` - List discovery jobs
- `GET /api/discovery/jobs/:id` - Get job status

### Vendor Enrichment
- `POST /api/enrichment/process` - Process vendor enrichment
- `GET /api/enrichment/status` - Get enrichment status

### Executive Contacts
- `GET /api/contacts/search` - Search executive contacts
- `POST /api/contacts/verify` - Verify contact information

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@bizzintell.com or create an issue in this repository.

## Roadmap

- [ ] Advanced AI analytics dashboard
- [ ] Mobile application (iOS/Android)
- [ ] White-label solutions
- [ ] International market expansion
- [ ] Advanced predictive analytics
- [ ] CRM/ERP integrations

---

**BizzIntell** - Transforming vendor intelligence with AI-powered automation.

*Built with ❤️ using React, TypeScript, and Supabase*
