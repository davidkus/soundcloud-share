/** @jsx React.DOM */
module.exports = React.createClass({

  audioPlayer: function() {
    return ReactDOM.findDOMNode(this.refs.audioObject);
  },

  componentDidMount: function() {
    this.audioPlayer().ontimeupdate = this.onTimeUpdate;
    this.audioPlayer().oncanplay = this.synctime;
    this.audioPlayer().onended = this.props.onEnded;
  },

  componentWillReceiveProps: function(nextProps) {
    var didProvideTrack = nextProps.track && nextProps.track.id;
    var didHaveTrack = this.props.track && this.props.track.id;

    if (didProvideTrack && ((didHaveTrack && nextProps.track.id != this.props.track.id) || !didHaveTrack)) {
      this.audioPlayer().load();
    }

    if (nextProps.volume != this.audioPlayer().volume) {
      this.audioPlayer().volume = nextProps.volume;
    }

    if (nextProps.playing) {
      this.audioPlayer().play();
    }

    if (!nextProps.playing) {
      this.audioPlayer().pause();
    }
  },

  onTimeUpdate: function() {
    this.syncTime();
    this.props.onTimeUpdate(this.audioPlayer().currentTime);
  },

  syncTime: function() {
    var timeDifference = Math.abs(this.audioPlayer().currentTime - this.props.currentTime);

    if (timeDifference > 2) {
      this.audioPlayer().currentTime = this.props.currentTime;
    }
  },

  render: function() {
    var source = "";

    if (this.props.track) {
      source = (<source src={ this.props.track.stream_url + "?client_id=" + this.props.clientId }/>);
    }

    return (
      <audio ref="audioObject" preload="true">
        { source }
      </audio>
    );
  }

});
