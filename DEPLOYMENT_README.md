# BizzIntell - Deployment Guide

## Overview
BizzIntell is a React/TypeScript application with Supabase backend for vendor discovery and management. This guide covers deployment on a Linux server.

## Application Architecture
- **Frontend**: React 18 + TypeScript + Vite
- **Backend**: Supabase (PostgreSQL + Edge Functions)
- **Styling**: Tailwind CSS
- **State Management**: React Context
- **Routing**: React Router v6

## Server Requirements

### Minimum Specifications
- **CPU**: 2 cores (2.0 GHz or higher)
- **RAM**: 4GB
- **Storage**: 20GB SSD
- **OS**: Ubuntu 20.04 LTS or higher / CentOS 8+ / Debian 11+

### Recommended Specifications
- **CPU**: 4 cores (2.5 GHz or higher)
- **RAM**: 8GB
- **Storage**: 50GB SSD
- **OS**: Ubuntu 22.04 LTS
- **Network**: 100 Mbps minimum, 1 Gbps recommended

### Production Specifications (High Traffic)
- **CPU**: 8 cores (3.0 GHz or higher)
- **RAM**: 16GB
- **Storage**: 100GB SSD
- **OS**: Ubuntu 22.04 LTS
- **Network**: 1 Gbps
- **Load Balancer**: Recommended for high availability

## Prerequisites

### System Dependencies
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 18+ and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Git
sudo apt install git -y

# Install Nginx (for reverse proxy)
sudo apt install nginx -y

# Install PM2 (process manager)
sudo npm install -g pm2

# Install build tools
sudo apt install build-essential -y
```

### Verify Installations
```bash
node --version  # Should be 18.x or higher
npm --version   # Should be 9.x or higher
git --version   # Should be 2.x or higher
nginx -v        # Should be 1.18+ or higher
pm2 --version   # Should be 5.x or higher
```

## Environment Setup

### 1. Clone Repository
```bash
git clone <your-repository-url>
cd BizzIntell
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Environment Variables
Create `.env` file in the root directory:
```bash
# Supabase Configuration
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

# API Keys (if using external services)
VITE_SERP_API_KEY=your_serp_api_key
VITE_SIGNALHIRE_API_KEY=your_signalhire_api_key

# Environment
NODE_ENV=production
```

### 4. Build Application
```bash
npm run build
```

## Deployment Options

### Option 1: Nginx + PM2 (Recommended)

#### 1. Configure PM2
Create `ecosystem.config.js`:
```javascript
module.exports = {
  apps: [{
    name: 'bizzintell',
    script: 'npm',
    args: 'run preview',
    cwd: '/path/to/your/BizzIntell',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 4173
    }
  }]
}
```

#### 2. Start Application
```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

#### 3. Configure Nginx
Create `/etc/nginx/sites-available/bizzintell`:
```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com www.your-domain.com;

    # SSL Configuration
    ssl_certificate /path/to/your/certificate.crt;
    ssl_certificate_key /path/to/your/private.key;

    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Root directory
    root /path/to/your/BizzIntell/dist;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss;

    # Handle React Router
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Proxy API calls to Supabase (if needed)
    location /api/ {
        proxy_pass https://your-project.supabase.co/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### 4. Enable Site
```bash
sudo ln -s /etc/nginx/sites-available/bizzintell /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Option 2: Docker Deployment

#### 1. Create Dockerfile
```dockerfile
# Build stage
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built app
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### 2. Create nginx.conf
```nginx
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri $uri/ /index.html;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
}
```

#### 3. Build and Run
```bash
docker build -t bizzintell .
docker run -d -p 80:80 --name bizzintell-app bizzintell
```

## SSL Certificate Setup

### Using Let's Encrypt (Free)
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

## Monitoring and Maintenance

### PM2 Monitoring
```bash
# Monitor processes
pm2 monit

# View logs
pm2 logs bizzintell

# Restart application
pm2 restart bizzintell

# Update application
git pull
npm install
npm run build
pm2 restart bizzintell
```

### System Monitoring
```bash
# Install monitoring tools
sudo apt install htop iotop nethogs -y

# Monitor system resources
htop
df -h
free -h
```

### Backup Strategy
```bash
# Create backup script
#!/bin/bash
BACKUP_DIR="/backups/bizzintell"
DATE=$(date +%Y%m%d_%H%M%S)

# Backup application
tar -czf $BACKUP_DIR/app_$DATE.tar.gz /path/to/your/BizzIntell

# Backup environment variables
cp /path/to/your/BizzIntell/.env $BACKUP_DIR/env_$DATE

# Keep only last 7 days of backups
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
```

## Performance Optimization

### Nginx Optimization
```nginx
# Add to nginx.conf
worker_processes auto;
worker_rlimit_nofile 65535;

events {
    worker_connections 65535;
    use epoll;
    multi_accept on;
}

http {
    # Enable gzip
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
```

### Node.js Optimization
```bash
# Set Node.js memory limit
export NODE_OPTIONS="--max-old-space-size=4096"

# Use PM2 cluster mode for multiple CPU cores
pm2 start ecosystem.config.js -i max
```

## Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   sudo netstat -tulpn | grep :80
   sudo kill -9 <PID>
   ```

2. **Permission denied**
   ```bash
   sudo chown -R $USER:$USER /path/to/your/BizzIntell
   sudo chmod -R 755 /path/to/your/BizzIntell
   ```

3. **Build fails**
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   npm run build
   ```

4. **Nginx configuration error**
   ```bash
   sudo nginx -t
   sudo systemctl status nginx
   ```

### Log Locations
- **PM2 logs**: `~/.pm2/logs/`
- **Nginx logs**: `/var/log/nginx/`
- **System logs**: `/var/log/syslog`

## Security Considerations

1. **Firewall Setup**
   ```bash
   sudo ufw allow 22    # SSH
   sudo ufw allow 80    # HTTP
   sudo ufw allow 443   # HTTPS
   sudo ufw enable
   ```

2. **Regular Updates**
   ```bash
   # Set up automatic security updates
   sudo apt install unattended-upgrades
   sudo dpkg-reconfigure -plow unattended-upgrades
   ```

3. **Environment Variables**
   - Never commit `.env` files to version control
   - Use strong, unique API keys
   - Rotate keys regularly

## Support

For deployment issues:
1. Check logs: `pm2 logs` and `sudo journalctl -u nginx`
2. Verify environment variables are set correctly
3. Ensure all dependencies are installed
4. Check firewall and network connectivity

## Cost Estimation

### Monthly Server Costs (AWS EC2)
- **Minimum**: t3.medium (2 vCPU, 4GB RAM) - ~$30/month
- **Recommended**: t3.large (2 vCPU, 8GB RAM) - ~$60/month
- **Production**: t3.xlarge (4 vCPU, 16GB RAM) - ~$120/month

### Additional Costs
- Domain name: ~$10-15/year
- SSL certificate: Free (Let's Encrypt)
- Supabase: Free tier available, paid plans start at $25/month 