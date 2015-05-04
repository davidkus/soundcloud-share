/** @jsx React.DOM */
var ClassNames = require('classnames');

module.exports = React.createClass({

  render: function() {
    var iconClass = ClassNames({
      'pause': this.props.playing,
      'play': !this.props.playing,
      'icon': true
    });

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
