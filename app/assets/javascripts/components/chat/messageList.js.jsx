/** @jsx React.DOM */
var Message = require('./message');

module.exports = React.createClass({

  componentDidMount: function() {
    this.scrollToBottom();
  },

  componentDidUpdate: function() {
    this.scrollToBottom();
  },

  scrollToBottom: function() {
    $(this.refs.messageList.getDOMNode()).stop().animate({
      scrollTop: $(this.refs.messageList.getDOMNode())[0].scrollHeight
    }, 800);
  },

  render: function() {
    var createMessage = function(message, index) {
      return (
        <Message key={ index } author={ message.username } avatar={ message.avatar }
                 message={ message.message } timestamp={ message.timestamp } />
      );
    };

    return (
      <div ref="messageList" className="ui comments">
        { this.props.messages.map(createMessage) }
      </div>
    );
  }
});
