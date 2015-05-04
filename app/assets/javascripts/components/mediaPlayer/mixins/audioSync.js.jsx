/** @jsx React.DOM */
module.exports ={

  checkTimeDifference: function(oldTime, newTime) {
    var timeDifference = Math.abs(oldTime - newTime);

    return timeDifference > 2;
  }

};
