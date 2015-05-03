/** @jsx React.DOM */
module.exports = React.createClass({

  seekTo: function(e){
    var container = $(this.refs.progressBar.getDOMNode());
    var containerStartX = container.offset().left;
    var percent = (e.clientX - containerStartX) / container.width();
    percent = percent >= 1 ? 1 : percent;

    time = percent * this.props.duration;

    this.props.seekTo(time);
  },

  render: function() {
    var percent = this.props.currentTime / Math.max(this.props.duration, 1) * 100;
    var style = { width: percent + "%" };

    return (
      <div ref="progressBar" className="audio-progress-container" onClick={this.seekTo}>
        <div className="audio-progress" style={style}></div>
      </div>
    );
  }

});
