/** @jsx React.DOM */
var Message = require('./message');

module.exports = React.createClass({

  componentDidMount: function() {
    this.scrollToBottom();
  },

  componentDidUpdate: function() {
    this.scrollToBottom();
  },

  /*
   * Scrolls to the bottom of the chat message list
   */
  scrollToBottom: function() {
    $(this.refs.messageList.getDOMNode()).stop().animate({
      scrollTop: $(this.refs.messageList.getDOMNode())[0].scrollHeight
    }, 800);
  },

  render: function() {
    var createMessage = function(message, index) {
      return (
        <Message key={ index } message={ message } />
      );
    };

    return (
      <div ref="messageList" className="ui comments">
        { this.props.messages.map(createMessage) }
      </div>
    );
  }
});
