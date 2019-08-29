class Timer{
  var hrs,secs,mins;
  String get sec{
    if(this.secs == null){
      return "0";
    }
    return secs.toString();
  }

  String get min{
    if(this.mins == null){
      return "0";
    }
    else{
      return this.mins.toString();
    }
  }
  String get hr{
    if(this.hrs == null){
      return "0";
    }
    else{
      return hrs.toString();
    }
  }
  Timer({var duration}){
    secs  = duration;
    if(duration >= 60){
        mins = duration/60;
        mins = mins.floor();
        secs = duration % 60;
      }
      if(mins !=null && mins >= 60){
          hrs = mins/60;
          hrs = hrs.floor();
          mins = mins % 60;
      }
  }
}