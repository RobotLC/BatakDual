class CountDownTimer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last

  CountDownTimer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  // Starting the timer
  void start(int time) {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
    totalTime=time;
  }

  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime >= totalTime) {
      return true;
    } else {
      return false;
    }
  }
  
  int ellapsedTime(){
    int passedTime = millis() - savedTime;
    if (passedTime > totalTime){
      passedTime=totalTime;
    }
    return passedTime;
  }
  
}
