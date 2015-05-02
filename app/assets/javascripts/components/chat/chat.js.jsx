/** @jsx React.DOM */
var Chat = React.createClass({
  mixins: [ReactFireMixin],

  getInitialState: function() {
    return {
      messages: [],
      loading: true
    };
  },

  componentWillMount: function() {
    this.firebaseRef = new Firebase(this.props.firebaseUrl + "/chats/" + this.props.chatId + '/messages');

    this.firebaseRef.authWithCustomToken(this.props.token, function(error, authData) {
      if (error) {
        console.log('Login Failed');
      } else {
        console.log('Login Valid');
      }
    });

    this.firebaseRef.once("value", function(data) {
      this.setState({ loading: false });
    }.bind(this));

    this.bindAsArray(this.firebaseRef.limitToLast(100), "messages");
  },

  submitMessage: function(message) {
    var date = new Date();
    this.firebaseRef.push({
      userId: this.props.userId,
      username: this.props.username,
      avatar: this.props.avatar,
      message: message,
      timestamp: date.getTime(),
    });
    this.forceUpdate();
  },

  render: function() {
    containerClass = this.state.loading ? "ui chat raised loading segment" : "ui chat raised segment"

    return (
      <div className={ containerClass }>
        <MessageList messages={ this.state.messages } />
        <ChatInput onClick={ this.submitMessage } />
      </div>
    );
  }
});
