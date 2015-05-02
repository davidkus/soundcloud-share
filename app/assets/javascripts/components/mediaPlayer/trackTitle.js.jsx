/** @jsx React.DOM */
var TrackTitle = React.createClass({

  getFormattedTrackName: function(track) {
    var trackName = "";

    trackName += (track && track.title) ? track.title : I18n.t('components.mediaPlayer.unknown');
    trackName += " - ";
    trackName += (track && track.user) ? track.user.username : I18n.t('components.mediaPlayer.anonymous');

    return trackName;
  },

  getPermalink: function(track) {
    return (track && track.permalink_url) ? track.permalink_url : "#"
  },

  render: function() {
    return (
      <div className="ui header">
        <a href={ this.getPermalink(this.props.track) } target="_blank">
          <i className="soundcloud icon"></i>
        </a>
        <span className="title-text">
          { this.getFormattedTrackName(this.props.track) }
        </span>
      </div>
    );
  }

});
