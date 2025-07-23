# Streetscape Perception Survey Platform (SP-Survey)

<img src="./public/cover-image.png" alt="Streetscape Perception Survey Cover" width="600">

[![Paper](https://img.shields.io/badge/📄-Published_Paper-9cf)](https://www.sciencedirect.com/science/article/pii/S0360132325000514)
[![Preprint](https://img.shields.io/badge/📥-Preprint_PDF-9cf)](https://arxiv.org/pdf/2410.11887)
[![Website](https://img.shields.io/badge/🌐-Project_Website_&_Dataset-blue)](https://thermal-affordance.ual.sg)
[![Blog](https://img.shields.io/badge/📝-Blog_Post-green)](https://sijie-yang.com/blog/2025/thermal-comfort/)
[![Blog](https://img.shields.io/badge/🔬-Lab_Post-green)](https://ual.sg/post/2025/01/25/new-paper-thermal-comfort-in-sight/)
[![Thermal Affordance](https://img.shields.io/badge/🔗-Thermal_Affordance_Study-blue)](https://github.com/Sijie-Yang/Thermal-Affordance)

A simple and powerful platform for conducting streetscape perception surveys with image-based questions. Deploy in minutes with Supabase and Vercel.

**🌐 Live Demo: [https://streetscape-perception-survey.vercel.app/](https://streetscape-perception-survey.vercel.app/)**

**This platform was initially developed for the [Thermal Affordance research](https://github.com/Sijie-Yang/Thermal-Affordance), which introduces a novel framework for assessing urban thermal comfort using street view imagery and human perception surveys.**

## 🚀 Quick Deploy (5 minutes)

### Step 1: Set up Supabase Database (2 minutes)

1. **Create Account**: Go to [supabase.com](https://supabase.com) and create a free account
2. **Create Project**: Click "New Project" and create a project
3. **Setup Database**: Go to SQL Editor and run this script to create your database:

```sql
-- Create survey responses table
CREATE TABLE survey_responses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  participant_id TEXT,
  responses JSONB NOT NULL,
  displayed_images JSONB,
  survey_metadata JSONB,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create images table for managing street view images
CREATE TABLE street_images (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  filename TEXT NOT NULL,
  url TEXT NOT NULL,
  description TEXT,
  category TEXT,
  active BOOLEAN DEFAULT true
);

-- Enable Row Level Security
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE street_images ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (adjust as needed)
CREATE POLICY "Allow public insert" ON survey_responses FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public select" ON street_images FOR SELECT USING (active = true);
```

4. **Get API Keys**: Go to Settings → API Keys and Data API panels, and copy your:
   - Project URL
   - Anon public key
   
   **💾 Save these for later use - you'll need them in Step 3!**

### Step 2: Upload Your Street Images (1 minute)

1. **Create Storage**: In Supabase, go to Storage
2. **Create Bucket**: Create a new bucket called `street-images`, and make it a public bucket.
3. **Upload Images**: Upload your street view images to this bucket
4. **Get Folder Base URL**: Your images folder base URL is: `https://your-project.supabase.co/storage/v1/object/public/street-images/`
   
   Individual images will be: `https://your-project.supabase.co/storage/v1/object/public/street-images/filename.jpg`

   **💾 Save this folder base URL - you'll need it in Step 3!**

### Step 3: Configure Your Survey (1 minute)

1. **Clone and Install**:
```bash
git clone https://github.com/yourusername/streetscape-perception-survey.git
cd streetscape-perception-survey
./deploy.sh
```

2. **Add Credentials**: The script will create `.env.local` - edit it with your Supabase credentials:
```env
REACT_APP_SUPABASE_URL=https://your-project.supabase.co
REACT_APP_SUPABASE_ANON_KEY=your-anon-key
```

3. **⚠️ IMPORTANT: Configure Your Images**: Edit `src/config/streetImages.js` and **MUST REPLACE** with your own data:

```javascript
// 🔧 STEP 1: Replace with YOUR Supabase project URL
const SUPABASE_STORAGE_URL = "https://YOUR-PROJECT-ID.supabase.co/storage/v1/object/public/street-images";

// 🔧 STEP 2: Replace with YOUR actual image filenames
const imageFilenames = [
  "your_street_image_1.jpg",
  "your_street_image_2.jpg", 
  "your_street_image_3.jpg",
  "your_street_image_4.jpg",
  // Add ALL your uploaded image filenames here...
];
```

**🚨 CRITICAL**: You MUST replace both:
- `YOUR-PROJECT-ID` with your actual Supabase project ID
- The image filenames with your actual uploaded image names

**🚀 Quick way to get all filenames**: After uploading images to Supabase Storage, you can:
- In Supabase Storage, select all your images and copy the filenames
- Or use this command in your terminal to list all files: `ls your_images_folder/`
- Or in Supabase Storage interface, you can see all filenames in the file list

4. **Customize Survey** (optional):
   - Edit `src/config/surveyConfig.js` to change title, description, and lab information
   - Edit `src/config/questions.js` to modify questions

### Step 4: Deploy to Vercel (1 minute)

1. **Push to GitHub**: 
```bash
git add .
git commit -m "Initial setup"
git push origin main
```

2. **Deploy**: Go to [vercel.com](https://vercel.com) and sign up
3. **Import Project**: Click "New Project" and import your GitHub repository
4. **Add Environment Variables**: In Vercel project settings, add these environment variables:
   - Name: `REACT_APP_SUPABASE_URL`, Value: `https://your-project.supabase.co`
   - Name: `REACT_APP_SUPABASE_ANON_KEY`, Value: `your-anon-key-here`
5. **Deploy**: Click Deploy

**🎉 Your survey will be live at `https://your-project.vercel.app`**

## 📊 View Survey Results

1. Go to your Supabase dashboard
2. Navigate to Table Editor → survey_responses
3. View all responses in real-time
4. Export data as CSV for analysis

## 📚 Citation

This survey platform was initially developed for the following research:

```bibtex
@article{yang2025thermal,
  title={Thermal comfort in sight: Thermal affordance and its visual assessment for sustainable streetscape design},
  author={Yang, Sijie and Chong, Adrian and Liu, Pengyuan and Biljecki, Filip},
  journal={Building and Environment},
  pages={112569},
  year={2025},
  publisher={Elsevier}
}
```
**If you use this platform in your research, please consider citing the above paper.**

## 🎨 Customization Guide

### Survey Configuration

Edit `src/config/surveyConfig.js`:

```javascript
export const surveyConfig = {
  title: "Your Survey Title",
  description: "Your survey description...",
  logo: "https://your-supabase-url/storage/v1/object/public/street-images/lab-logo.jpg",
  labDescription: "Your lab description...",
  // ... other settings
};
```

### 📝 How to Modify Survey Questions

All survey questions are configured in `src/config/questions.js`. The system uses pre-generated random images for consistency.

#### 🔧 **Understanding the Image System**

Images are pre-generated when the survey loads using this logic:
```javascript
const displayedImages = {
  safety_perception: getRandomImages("safety_perception", 2), // 2 images, choose 1
  attractiveness_perception: getRandomImages("attractiveness_perception", 2), // 2 images, choose 1
  liveliness_perception: getRandomImages("liveliness_perception", 4), // 4 images, choose 1
  // ... more questions
};
```

#### 1. **Image Selection Questions** (Choose 1 from multiple images)

**Current example**: Safety perception question
```javascript
{
  type: "imagepicker",
  name: "safety_perception",
  title: "Safety Perception", 
  description: "Which street environment do you perceive to be the SAFEST?",
  choices: displayedImages.safety_perception, // Uses pre-generated images
  multiSelect: false
}
```

**To modify**:
1. **Change the question text**: Edit `title` and `description`
2. **Change number of images**: Modify the count in `generateQuestionImages()`:
   ```javascript
   safety_perception: getRandomImages("safety_perception", 4), // Change 2 to 4 for more options
   ```
3. **Change perception type**: Replace "safety_perception" with your own (e.g., "beauty_perception")
4. **Add new image question**: Add both in `generateQuestionImages()` and in the survey page

**🚨 IMPORTANT**: Current survey has 6 perception questions:
- `safety_perception` (2 choose 1) - Which street is SAFEST?
- `attractiveness_perception` (2 choose 1) - Which street is most ATTRACTIVE?  
- `walkability_perception` (2 choose 1) - Which street is most WALKABLE?
- `liveliness_perception` (4 choose 1) - Which street is most LIVELY?
- `relaxation_perception` (4 choose 1) - Which street is most RELAXING?
- `cleanliness_perception` (4 choose 1) - Which street is most CLEAN?

#### 2. **Likert Scale Rating** (Rate 1-5 scale with image)

**Current example**: Comfort rating
```javascript
{
  type: "image",
  name: "comfort_image", 
  imageLink: displayedImages.comfort_rating[0]?.imageLink, // Shows 1 random image
},
{
  type: "radiogroup",
  name: "comfort_level",
  title: "How comfortable would you feel walking in this street?",
  choices: [
    { value: 1, text: "Very Uncomfortable" },
    { value: 2, text: "Uncomfortable" },
    { value: 3, text: "Neutral" },
    { value: 4, text: "Comfortable" },
    { value: 5, text: "Very Comfortable" }
  ]
}
```

**To modify**:
1. **Change the question**: Edit `title` 
2. **Change scale labels**: Modify the `choices` array text
3. **Change scale range**: Add/remove choice options (e.g., 1-7 scale)
4. **Ensure image is generated**: Make sure `comfort_rating` is in `generateQuestionImages()`

#### 3. **Multiple Choice Questions** (Select one option)

**Current example**: Age demographics
```javascript
{
  name: "age",
  title: "What is your age group?",
  type: "radiogroup",
  choices: [
    { value: "18-24", text: "18-24 years old" },
    { value: "25-34", text: "25-34 years old" },
    { value: "35-44", text: "35-44 years old" },
    // ... more options
  ]
}
```

**To modify**:
- Change `title` to your question
- Replace `choices` array with your options
- Each choice needs `value` (data saved) and `text` (displayed)

#### 4. **Checkbox Questions** (Select multiple options with image)

**Current example**: Street elements identification
```javascript
{
  type: "image", 
  name: "elements_image",
  imageLink: displayedImages.street_elements[0]?.imageLink, // Shows 1 random image
},
{
  type: "checkbox",
  name: "visible_elements",
  title: "Which elements do you notice in this street? (Select all that apply)",
  choices: [
    "Trees and vegetation",
    "Street furniture (benches, lights)",
    "Bicycle lanes", 
    "Pedestrian crossings",
    "Public art or decorations",
    // ... more options
  ]
}
```

**To modify**:
1. **Change the question**: Edit `title`
2. **Change options**: Replace `choices` array with your options
3. **Ensure image is generated**: Make sure `street_elements` is in `generateQuestionImages()`

#### 5. **Ranking Questions** (Drag & drop to order with image)

**Current example**: Feature importance ranking
```javascript
{
  type: "image", 
  name: "ranking_image",
  imageLink: displayedImages.feature_ranking[0]?.imageLink, // Shows 1 random image
},
{
  type: "ranking",
  name: "street_features",
  title: "Based on the image above, drag to rank these features from most important (top) to least important (bottom):",
  choices: [
    { value: "safety", text: "Safety and security" },
    { value: "greenery", text: "Trees and greenery" },
    { value: "walkability", text: "Wide sidewalks and walkability" },
    { value: "aesthetics", text: "Visual appeal and aesthetics" },
    { value: "amenities", text: "Street furniture and amenities" }
  ]
}
```

**To modify**:
1. **Change the question**: Edit `title`
2. **Change ranking items**: Replace `choices` array (use `value` and `text` format)
3. **Ensure image is generated**: Make sure `feature_ranking` is in `generateQuestionImages()`

#### 6. **Text Input Questions** (Open-ended responses with image)

**Current example**: Additional feedback
```javascript
{
  type: "image", 
  name: "feedback_image",
  imageLink: displayedImages.open_feedback[0]?.imageLink, // Shows 1 random image
},
{
  type: "comment",
  name: "general_feedback", 
  title: "Looking at this street, what makes a street environment appealing to you? (Optional)",
  description: "Please share your thoughts about streetscape design, walkability, or any other aspects that matter to you.",
  maxLength: 500
}
```

**To modify**:
1. **Change the question**: Edit `title` and `description`
2. **Adjust text box**: Change `maxLength` or use `type: "text"` for single-line
3. **Ensure image is generated**: Make sure `open_feedback` is in `generateQuestionImages()`

#### 7. **Adding New Image Questions**

To add a completely new image-based question:

**Step 1**: Add to `generateQuestionImages()`:
```javascript
const questionImages = {
  // ... existing questions
  your_new_question: getRandomImages("your_new_question", 4), // 4 images to choose from
};
```

**Step 2**: Add to the appropriate survey page:
```javascript
{
  type: "imagepicker",
  name: "your_new_question",
  title: "Your Question Title",
  description: "Your question description",
  choices: displayedImages.your_new_question,
  multiSelect: false // or true for multiple selection
}
```

#### 8. **Question Logic & Conditions**

Make questions appear based on previous answers:

```javascript
{
  name: "follow_up_question",
  title: "Follow-up question",
  type: "text",
  visibleIf: "{previous_question} = 'specific_answer'"
}
```

#### 9. **Changing Question Order**

Questions appear in the order they're listed in each page's `elements` array. Simply reorder them in the file.

#### 10. **Making Questions Optional**

Remove `required: true` or set `required: false` to make any question optional.

### Current Survey Structure

The default survey includes 6 parts:

1. **Part 1: Demographics** (Optional) - Age, location, income, education, outdoor activities
2. **Part 2: Street Perception** (6 questions) - Safety, attractiveness, walkability, liveliness, relaxation, cleanliness  
3. **Part 3: Comfort Rating** - 1-5 scale rating with image
4. **Part 4: Street Elements** - Checkbox identification with image
5. **Part 5: Feature Ranking** - Drag & drop ranking with image
6. **Part 6: Open Feedback** - Text input with image

## 🔧 Advanced Configuration

### Custom Styling

Edit `src/styles/globals.css` to match your brand:
- Colors
- Fonts
- Layout spacing
- Component styling



### Data Export

Access your data via Supabase API or dashboard:
- Real-time responses
- CSV export
- JSON format
- Direct database queries

## 📱 Mobile Responsive

The survey automatically adapts to:
- Desktop computers
- Tablets
- Mobile phones
- Different screen orientations

## 🔒 Privacy & Security

- No personal data stored by default
- Supabase handles data security
- GDPR compliant
- Optional participant anonymization

## 🆘 Troubleshooting

### Images not loading?
- Check Supabase storage bucket is public
- Verify image URLs are correct
- Ensure images are in supported formats (JPG, PNG, WebP)

### Survey not saving responses?
- Check Supabase connection
- Verify environment variables in `.env.local`
- Check browser console for errors

### Deployment issues?
- Ensure all environment variables are set in Vercel
- Check build logs for errors
- Verify GitHub repository is connected

### Local development
```bash
npm install
npm start
```

## 📈 Analytics

Track survey performance:
- Response rates
- Completion times
- Drop-off points
- Device/browser statistics

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - feel free to use for research and commercial projects.

## 📞 Support

- GitHub Issues: Report bugs and request features
- All configuration is in the `src/config/` folder
- Check console logs for debugging information

---

**That's it! Your streetscape perception survey is ready to collect responses! 🎉**

---
