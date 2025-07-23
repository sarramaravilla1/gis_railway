#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Streetscape Perception Survey Platform Deployment${NC}"
echo -e "${BLUE}=================================================${NC}"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Error: Node.js is not installed. Please install Node.js first.${NC}"
    echo -e "${YELLOW}Visit: https://nodejs.org/${NC}"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ Error: npm is not installed. Please install npm first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js and npm are installed${NC}"

# Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies installed successfully!${NC}"
else
    echo -e "${RED}❌ Failed to install dependencies.${NC}"
    exit 1
fi

# Check if .env.local exists
if [ ! -f .env.local ]; then
    echo -e "${YELLOW}⚠️  .env.local file not found.${NC}"
    echo -e "${YELLOW}📝 Creating .env.local template...${NC}"
    
    cat > .env.local << EOF
# Supabase Configuration
REACT_APP_SUPABASE_URL=your-supabase-project-url
REACT_APP_SUPABASE_ANON_KEY=your-supabase-anon-key

# Example:
# REACT_APP_SUPABASE_URL=https://abcdefghijklmnop.supabase.co
# REACT_APP_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
EOF
    
    echo -e "${GREEN}✅ .env.local template created!${NC}"
    echo -e "${RED}⚠️  IMPORTANT: Please edit .env.local with your Supabase credentials before running the app.${NC}"
fi

# Start development server
echo -e "${YELLOW}🔧 Starting development server...${NC}"
echo -e "${BLUE}📖 The survey will be available at: http://localhost:3000${NC}"
echo -e "${BLUE}📊 View responses in your Supabase dashboard${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. 🔑 Configure your Supabase credentials in .env.local"
echo -e "2. 🖼️  Upload your street images to Supabase Storage"
echo -e "3. ⚙️  Edit src/config/streetImages.js with your image URLs"
echo -e "4. 📝 Customize your survey in src/config/questions.js"
echo -e "5. 🎨 Update survey info in src/config/surveyConfig.js"
echo ""
echo -e "${GREEN}🚀 Starting the application...${NC}"

npm start 