# Project 4 - Trivia

Submitted by: **Richard Maliyetu**

**Trivia** is an iOS app that challenges users with multiple-choice questions. Players must select the correct answer from a set of choices, earning a point for each correct response. Users have the ability to restart the game. Unlike Project 3, where data was hardcoded, Project 4 fetches questions dynamically from an API:[ Open Trivia Database.](https://opentdb.com/api.php?amount=20&category=21&difficulty=easy&type=multiple) . This enhancement allows users to choose a specific category of questions via an API call, providing a more dynamic and varied experience.

Time spent: **5** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] User can view and answer at least 5 trivia questions.
- [x] App retrieves question data from the Open Trivia Database API.
- [x] Fetch a different set of questions if the user indicates they would like to reset the game.
- [x] Users can see score after submitting all questions.
- [x] True or False questions only have two options.


The following **optional** features are implemented:

  
- [ ] Allow the user to choose a specific category of questions.
- [x] Provide the user feedback on whether each question was correct before navigating to the next.

## Video Walkthrough

<div>
    <a href="https://www.loom.com/share/e95fd4fbc7de4d559e93468163f44d55">
    </a>
    <a href="https://www.loom.com/share/e95fd4fbc7de4d559e93468163f44d55">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/e95fd4fbc7de4d559e93468163f44d55-65d9158f67b4da10-full-play.gif">
    </a>
  </div>

## Notes

Describe any challenges encountered while building the app.

- Fetching API Data: Parsing JSON and handling asynchronous network requests was challenging.
- Handling Errors & Latency: Implementing error handling and loading states ensured smooth gameplay.
- Managing Game State: Resetting scores and fetching new questions required careful state management.
- UI Updates: Dynamically displaying questions while maintaining a responsive layout was tricky.

## License

    Copyright 2025 richard maliyetu

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.