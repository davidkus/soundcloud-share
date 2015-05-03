/** @jsx React.DOM */
module.exports = React.createClass({

  render: function() {
    var iconClass = this.props.playing ? "pause icon" : "play icon";

    return (
      <div className="ui icon buttons media-controls">
        <button className="ui button" onClick={ this.props.previousTrack }>
          <i className="backward icon"></i>
        </button>
        <button className="ui button" onClick={ this.props.playPause }>
          <i className={ iconClass }></i>
        </button>
        <button className="ui button" onClick={ this.props.nextTrack }>
          <i className="forward icon"></i>
        </button>
      </div>
    );
  }

});
