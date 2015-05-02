/** @jsx React.DOM */
var VolumeControl = React.createClass({

  getInitialState: function() {
    return {
      lastVolume: this.props.volume
    }
  },

  componentDidMount: function() {
    $(this.refs.volumeButton.getDOMNode()).popup({
      inline   : true,
      hoverable: true,
      position : 'bottom center',
      delay: {
        show: 300,
        hide: 800
      }
    });
  },

  adjustVolumeTo: function(e) {
    var container = $(this.refs.audioVolumePercentContainer.getDOMNode());
    var containerStartY = container.offset().top;
    var percent = (e.clientY - containerStartY) / container.height();
    percent = 1 - percent;
    this.props.onChange(percent);
  },

  volumeToMax: function() {
    this.props.onChange(1);
  },

  volumeToMin: function() {
    this.props.onChange(0);
  },

  toggleMute: function() {
    if (this.props.volume == 0) {
      this.props.onChange(this.state.lastVolume);
    } else {
      this.setState({
        lastVolume: this.props.volume
      });
      this.volumeToMin();
    }
  },

  render: function() {
    var percent = this.props.volume * 100;
    var style = {top: (100 - percent) + "%"};

    var iconClass = this.props.volume == 0 ? "circular volume off icon volume-button" : "circular volume up icon volume-button";

    return (
      <span className="ui top right attached icon transparent label">
        <i className={ iconClass } ref="volumeButton" onClick={ this.toggleMute }></i>
        <div className="ui popup">
          <div ref="audioVolumePercentContainer" className="audio-volume-percent-container" onClick={this.adjustVolumeTo}>
            <div className="audio-volume-percent" style={style}></div>
          </div>
        </div>
      </span>
    );
  }

});
