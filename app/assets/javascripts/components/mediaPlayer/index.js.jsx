/** @jsx React.DOM */
var VolumeControl = require('./volumeControl');
var AudioPlayer = require('./audioPlayer');
var MediaControls = require('./mediaControls');
var SeekControl = require('./seekControl');
var TimeDisplay = require('./timeDisplay');
var TrackTitle = require('./trackTitle');
var UrlInput = require('./urlInput');
var ClassNames = require('classnames');
var AudioSyncMixin = require('./mixins/audioSync');

module.exports = React.createClass({
  mixins: [ReactFireMixin, AudioSyncMixin],

  getInitialState: function() {
    return {
      room: {
        playing: false,
        tracks: [],
        currentTime: 0,
        currentTrack: 0
      },
      loading: true,
      currentTime: 0,
      volume: 0.5
    };
  },

  componentWillMount: function() {
    var amOnline = new Firebase(this.props.firebaseUrl + '/.info/connected');

    this.firebaseRef = new Firebase(this.props.firebaseUrl + "/rooms/" + this.props.roomId);

    amOnline.on('value', function(snapshot) {
      if (snapshot.val() == true && this.props.canUpdate) {
        this.firebaseRef.onDisconnect().update({
          playing: false
        });
      }
    }.bind(this));

    this.firebaseRef.authWithCustomToken(this.props.token, function(error, authData) {
      if (error) {
        console.log('Login Failed');
      } else {
        console.log('Login Valid');
      }
    });

    this.firebaseRef.once("value", function(snapshot) {
      this.setState({ loading: false });
    }.bind(this));

    this.firebaseRef.on("value", function(snapshot) {
      var currentTime = snapshot.val().currentTime;

      if (this.checkTimeDifference(this.state.currentTime, currentTime)) {
        this.setState({
          currentTime: currentTime
        });
      }
    }.bind(this));

    this.bindAsObject(this.firebaseRef, "room");
  },

  componentWillUnmount: function() {
    if (this.props.canUpdate) {
      this.firebaseRef.update({
        playing: false
      });
    }

    this.firebaseRef.off()
  },

  getTracksFromUrl: function(soundcloudUrl) {
    if (!this.props.canUpdate) {
      return;
    }

    this.setState({ loading: true });
    $.get(
      'https://api.soundcloud.com/resolve.json',
      {
        url: soundcloudUrl,
        client_id: this.props.clientId
      },
      function(data) {
        var tracks = [];

        var trackMap = function(track) {
          return track;
        };

        if (data.kind && data.kind == "playlist") {
          tracks = data.tracks.map(trackMap);
        } else {
          tracks = [trackMap(data)];
        }

        this.firebaseRef.update({
          tracks: tracks,
          currentTime: 0,
          playing: false,
          currentTrack: 0
        });
      }.bind(this)
    ).done(function() {
      this.setState({
        loading: false
      });
    }.bind(this));
  },

  playPauseToggle: function() {
    if (!this.props.canUpdate) {
      return;
    }

    this.firebaseRef.update({
      playing: !this.state.room.playing
    });
  },

  setVolume: function(volume) {
    this.setState({ volume: volume });
  },

  nextTrack: function() {
    if (!this.props.canUpdate || this.state.room.currentTrack >= this.state.room.tracks.length - 1) {
      return;
    }

    this.firebaseRef.update({
      currentTime: 0,
      currentTrack: this.state.room.currentTrack + 1
    });
  },

  previousTrack: function() {
    if (!this.props.canUpdate || this.state.room.currentTrack == 0) {
      return;
    }

    this.firebaseRef.update({
      currentTime: 0,
      currentTrack: this.state.room.currentTrack - 1
    });
  },

  seekTo: function(currentTime) {
    if (!this.props.canUpdate) {
      return;
    }

    this.updateCurrentTime(currentTime);
  },

  updateCurrentTime: function(currentTime) {
    this.setState({
      currentTime: currentTime
    });

    if (!this.props.canUpdate) {
      return;
    }

    if (Math.floor(currentTime) == Math.floor(this.state.room.currentTime)) {
      return;
    }

    this.firebaseRef.update({
      currentTime: currentTime
    });
  },

  getIsPlaying: function() {
    if (this.state.room && this.state.room.playing) {
      return this.state.room.playing;
    } else {
      return false
    }
  },

  getCurrentTrackIndex: function() {
    if (this.state.room && this.state.room.currentTrack) {
      return this.state.room.currentTrack;
    } else {
      return 0;
    }
  },

  getCurrentTrack: function() {
    if (this.state.room && this.state.room.tracks) {
      return this.state.room.tracks[this.getCurrentTrackIndex()];
    } else {
      return {
        id: "-1"
      };
    }
  },

  getTracks: function() {
    if (this.state.room && this.state.room.tracks) {
      return this.state.room.tracks;
    } else {
      return [];
    }
  },

  render: function() {
    var containerClass = ClassNames(
      'ui media-player raised segment',
      { 'loading': this.state.loading }
    );

    var mediaControls = "";

    if (this.props.canUpdate) {
      mediaControls = (
        <div className="ui compact segment">
          <MediaControls playing={ this.getIsPlaying() }
                         playPause={ this.playPauseToggle }
                         previousTrack={ this.previousTrack }
                         nextTrack={ this.nextTrack } />
        </div>
      );
    }

    return (
      <div className={ containerClass }>
        <TrackTitle track={ this.getCurrentTrack() } />

        <VolumeControl volume={ this.state.volume } onChange={ this.setVolume } />

        <div className="ui segment">
          <SeekControl canUpdate={ this.props.canUpdate }
                       seekTo={ this.seekTo }
                       duration={ this.getCurrentTrack() ? this.getCurrentTrack().duration / 1000 : 0 }
                       currentTime={ this.state.currentTime } />
          <TimeDisplay currentTime={ this.state.currentTime * 1000 }
                       duration={ this.getCurrentTrack() ? this.getCurrentTrack().duration : 0 } />
        </div>

        { mediaControls }

        <UrlInput canUpdate={ this.props.canUpdate } onClick={ this.getTracksFromUrl } />

        <AudioPlayer track={ this.getCurrentTrack() }
                     currentTrackIndex={ this.getCurrentTrackIndex() }
                     playing={ this.getIsPlaying() }
                     currentTime={ this.state.currentTime }
                     clientId={ this.props.clientId }
                     volume={ this.state.volume }
                     onTimeUpdate={ this.updateCurrentTime }
                     onEnded={ this.nextTrack } />

      </div>
    );
  }

});
