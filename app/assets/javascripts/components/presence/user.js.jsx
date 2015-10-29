/** @jsx React.DOM */
module.exports = React.createClass({

  componentDidMount: function() {
    this.timer = setInterval(function() {
      ReactDOM.findDOMNode(this.refs.connectedOn).firstChild.data = moment(this.props.user.connectedOn).fromNow();
    }.bind(this), 1000);
  },

  componentWillUnmount: function() {
    clearInterval(this.timer);
  },

  render: function() {
    return (
      <div className="item">
        <img className="ui avatar image" src={ this.props.user.avatar } />
        <div className="content">
          <div className="header">{ this.props.user.username }</div>
          <span ref="connectedOn">
            { moment(this.props.user.connectedOn).fromNow() }
          </span>
        </div>
      </div>
    );
  }
});
