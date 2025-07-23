import React from "react";
import { Model } from "survey-core";
import { Survey } from "survey-react-ui";
import "survey-core/defaultV2.min.css";
import { saveSurveyResponse } from './lib/supabase';
import { surveyJson, displayedImages } from './config/questions';
import { surveyConfig } from './config/surveyConfig';
import { themeJson } from "./theme";

export default function App() {
  // Create survey model with the new configuration
  const model = new Model(surveyJson);
  
  // Apply theme
  model.applyTheme(themeJson);
  
  // Apply survey configuration
  model.title = surveyConfig.title;
  model.description = surveyConfig.description;
  model.logo = surveyConfig.logo;
  model.logoPosition = surveyConfig.logoPosition;
  
  // Apply settings
  Object.keys(surveyConfig.settings).forEach(key => {
    model[key] = surveyConfig.settings[key];
  });

  // Handle survey completion
  model.onComplete.add(async (survey, options) => {
    const responses = survey.data;
    
    // Combine user responses with displayed images information
    const completeData = {
      responses: responses,
      displayed_images: displayedImages,
      survey_metadata: {
        completion_time: new Date().toISOString(),
        user_agent: navigator.userAgent,
        screen_resolution: `${window.screen.width}x${window.screen.height}`,
        survey_version: "1.0"
      }
    };
    
    console.log("Survey completed with complete data:", completeData);
    
    // Save to Supabase
    const result = await saveSurveyResponse(completeData);
    
    if (result.success) {
      console.log("Survey response saved successfully!");
      alert("Thank you for completing the survey! Your responses have been saved.");
    } else {
      console.error("Failed to save survey response:", result.error);
      alert("There was an error saving your responses. Please try again.");
    }
  });
  
  return <Survey model={model} />;
}
