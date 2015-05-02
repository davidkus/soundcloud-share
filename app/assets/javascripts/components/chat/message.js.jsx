/** @jsx React.DOM */
var Message = React.createClass({

  render: function() {
    return (
      <div className="comment">
        <div className="avatar">
          <img src={ this.props.avatar }></img>
        </div>
        <div className="content">
          <span className="author">
            { this.props.author }
          </span>
          <div className="metadata">
            <div className="date">{ moment(this.props.timestamp).calendar() }</div>
          </div>
          <div className="text">
            { this.props.message }
          </div>
        </div>
      </div>
    );
  }
});
