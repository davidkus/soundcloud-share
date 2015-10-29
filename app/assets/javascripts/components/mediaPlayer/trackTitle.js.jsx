/** @jsx React.DOM */
module.exports = React.createClass({

  componentDidMount: function() {
    $(ReactDOM.findDOMNode(this.refs.title)).popup({
      popup: $(ReactDOM.findDOMNode(this.refs.popup))
    });
  },

  getFormattedTrackName: function() {
    var track = this.props.track;
    var trackName = "";

    trackName += (track && track.title) ? track.title : I18n.t('components.mediaPlayer.unknown');
    trackName += " - ";
    trackName += (track && track.user) ? track.user.username : I18n.t('components.mediaPlayer.anonymous');

    return trackName;
  },

  getPermalink: function() {
    var track = this.props.track;

    return (track && track.permalink_url) ? track.permalink_url : "#"
  },

  render: function() {
    return (
      <div className="ui header">
        <div ref="title" className="title-text">
          <a href={ this.getPermalink() } target="_blank">
            <i className="soundcloud icon"></i>
          </a>
          { this.getFormattedTrackName() }
        </div>
        <div ref="popup" className="ui popup">
          { this.getFormattedTrackName() }
        </div>
      </div>
    );
  }

});
