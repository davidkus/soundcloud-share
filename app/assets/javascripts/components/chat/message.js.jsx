/** @jsx React.DOM */
module.exports = React.createClass({

  render: function() {
    return (
      <div className="comment">
        <div className="avatar">
          <img src={ this.props.message.avatar }></img>
        </div>
        <div className="content">
          <span className="author">
            { this.props.message.username }
          </span>
          <div className="metadata">
            <div className="date">
              { moment(this.props.message.timestamp).calendar() }
            </div>
          </div>
          <div className="text">
            { this.props.message.message }
          </div>
        </div>
      </div>
    );
  }
});
