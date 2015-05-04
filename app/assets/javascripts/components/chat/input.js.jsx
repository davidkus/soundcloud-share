/** @jsx React.DOM */
module.exports = React.createClass({

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
      this.setState({text: ""});
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
    return (
      <div className="ui fluid action input">

        <input placeholder={ I18n.t('components.chat.placeholder') } type="text"
               onChange={ this.onChange } value={ this.state.text }
               autofocus="true" onKeyPress={ this.onKeyPress } />

        <div className="ui blue button" onClick={ this.onClick }>
          { I18n.t('components.chat.send') }
        </div>

      </div>
    );
  }
});
