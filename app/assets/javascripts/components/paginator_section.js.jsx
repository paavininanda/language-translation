var PaginatorSection = React.createClass({
  getInitialState: function () {
    return {
      total: this.props.totalPages,
      current: this.props.currentPage,
      visiblePages: 3,
      path: this.props.path
    };
  },

  render: function() {
    return (<Paginator total={this.state.total}
                   current={this.state.current}
                   visiblePages={this.state.visiblePages} path={this.state.path} />);
  }
});
