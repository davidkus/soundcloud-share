/** @jsx React.DOM */
var UrlInput = React.createClass({

  getInitialState: function() {
    return {
      text: ""
    }
  },

  onChange: function(e) {
    this.setState({ text: e.target.value });
  },

  onClick: function(e) {
    e.preventDefault();
    if (this.state.text && this.state.text.trim().length !== 0) {
      this.props.onClick( this.state.text );
    }
  },

  onKeyPress: function(e) {
    var keyCode = e.keyCode || e.which;
    if (keyCode === 13){
      // Enter pressed
      return this.onClick(e);
    }
  },

  render: function() {
    if (this.props.canUpdate) {
      return (
        <div className="ui fluid action input">
          <input type="text" onChange={ this.onChange }
                 onKeyPress={ this.onKeyPress }
                 value={ this.state.text }
                 placeholder={ I18n.t('components.mediaPlayer.placeholder') }/>
          <div className="ui blue button" onClick={ this.onClick }>
            { I18n.t('components.mediaPlayer.set') }
          </div>
        </div>
      );
    } else {
      return (
        <span></span>
      );
    }
  }

});
