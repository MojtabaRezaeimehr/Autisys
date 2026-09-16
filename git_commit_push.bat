
@echo off
echo Adding all changes to Git...
git add .

set /p commitmsg="Enter commit message: "
git commit -m "%commitmsg%"

echo Pushing to current branch...
git push origin main

pause
