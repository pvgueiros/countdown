# Quickstart: Countdown Widget Visual Layout

## Prerequisites
- Build passes with zero warnings.
- At least one Event exists with icon and color.
- Localization entries for “days”, “ago”, and “Today” added.

## Steps
1. Launch app and ensure an event has an icon (SF Symbol) and color.  
2. Add the small widget to the home screen and select the event.  
3. Verify layout:  
   - Icon top-left; title directly below the icon.  
   - Date bottom-left (locale medium).  
   - Countdown bottom-right with appropriate label:
     - Future: number + “days” with event color styling.  
     - Past: number + “ago” with gray styling.  
     - Today: “Today” with a small star below; event color styling.  
4. Change system locale; confirm date and labels remain correct and readable.  
5. Set device date to yesterday/tomorrow to validate state transitions across midnight.

## Validation
- No overlapping or clipping; long titles truncate.  
- VoiceOver announces title, date, and countdown context.  
- Numeric day counts and classification match the app’s semantics.


