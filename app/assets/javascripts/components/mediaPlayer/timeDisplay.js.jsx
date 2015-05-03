/** @jsx React.DOM */
module.exports = React.createClass({

  formatDuration: function(duration) {
    var seconds = duration.seconds();

    if (seconds < 10) {
      seconds = "0" + seconds;
    }

    var minutes = Math.floor(duration.asMinutes());

    if (minutes < 10) {
      minutes = "0" + minutes;
    }

    return minutes + ":" + seconds;
  },

  render: function() {
    var currentTime = moment.duration(this.props.currentTime);
    var duration = moment.duration(this.props.duration);

    return (
      <div className="time-display">
        { this.formatDuration(currentTime) } - { this.formatDuration(duration) }
      </div>
    );
  }

});
