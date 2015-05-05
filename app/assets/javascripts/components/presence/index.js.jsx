/** @jsx React.DOM */
var ClassNames = require('classnames');
var User = require('./user');

module.exports = React.createClass({
  mixins: [ReactFireMixin],

  getInitialState: function() {
    return {
      users: [],
      loading: true
    }
  },

  componentWillMount: function() {
    var amOnline = new Firebase(this.props.firebaseUrl + '/.info/connected');

    this.firebaseRef = new Firebase(this.props.firebaseUrl + '/presence/' + this.props.roomId);

    amOnline.on('value', function(snapshot) {
      if (snapshot.val() == true) {
        var now = new Date();

        this.firebaseRef.child(this.props.userId).onDisconnect().remove();
        this.firebaseRef.child(this.props.userId).set({
          username: this.props.username,
          avatar: this.props.avatar,
          connectedOn: now.getTime()
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

    this.bindAsArray(this.firebaseRef.limitToLast(100), "users");
  },

  componentWillUnmount: function() {
    this.firebaseRef.child(this.props.userId).remove();
  },

  render: function() {

    var segmentClass = ClassNames(
      'ui presence raised segment',
      { 'loading': this.state.loading }
    );

    var user = function(user, index) {
      return (
        <User key={ index } user={ user } />
      );
    };

    var sortByTime = function(first, second) {
      return first.connectedOn - second.connectedOn;
    };

    return (
      <div className={ segmentClass }>
        <div className="ui horizontal list">
          { this.state.users.sort(sortByTime).map(user) }
        </div>
      </div>
    );
  }
});
