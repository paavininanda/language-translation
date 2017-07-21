var BASE_SHIFT  = 0
  , LABEL_SHIFT = 1
  , LABELS = {
        prev:    '\u00AB',
        prevSet: '...',
        nextSet: '...',
        next:    '\u00BB'
  };

var Paginator = React.createClass({
    propTypes: {
        current:               React.PropTypes.number.isRequired,
        total:                 React.PropTypes.number.isRequired,
        visiblePages:          React.PropTypes.number.isRequired,
        labels:                React.PropTypes.object
    },

    calcBlocks: function () {
        var props      = this.props
          , total      = props.total
          , blockSize  = props.visiblePages
          , current    = props.current

          , blocks     = Math.ceil( total / blockSize ) 
          , currBlock  = Math.ceil( current / blockSize ) - LABEL_SHIFT;
        
        return {
            total:    blocks,
            current:  currBlock,
            size:     blockSize
        };
    },

    isPrevDisabled: function () {
      return this.props.current <= BASE_SHIFT+1;
    },

    isNextDisabled: function () {
      return this.props.current >= ( this.props.total );
    },

    isPrevMoreHidden: function () {
        var blocks = this.calcBlocks();
        return ( blocks.total === LABEL_SHIFT ) 
               || ( blocks.current === BASE_SHIFT );
    },

    isNextMoreHidden: function () {
        var blocks = this.calcBlocks();
        return ( blocks.total === LABEL_SHIFT ) 
               || ( blocks.current === (blocks.total - LABEL_SHIFT) );
    },

    visibleRange: function () {
        var blocks  = this.calcBlocks()
          , start   = blocks.current * blocks.size
          , delta   = this.props.total - start
          , end     = start + ( (delta > blocks.size) ? blocks.size : delta );
        return [ start + LABEL_SHIFT, end + LABEL_SHIFT ];
    },

    
    getLabels: function ( key ) {
        var labels = this.props.labels || {};
        return labels[ key ] || LABELS[ key ];
    },

    getNextPage: function () {
      if ( this.isNextDisabled() ) return;
      return (this.props.current + LABEL_SHIFT);
    },

    getPreviousPage: function () {
      if ( this.isPrevDisabled() ) return;
      return (this.props.current - LABEL_SHIFT);
    },
      

    render: function () {
        var labels = this.getLabels;

        return (
            <nav>
                <ul className="pagination">
                    <Page className="btn-prev-page"
                          key="btn-prev-page"
                          path={this.props.path}
                          isDisabled={this.isPrevDisabled()}
                          pageNumber={this.getPreviousPage()}>{labels('prev')}</Page>

                    <Page className="btn-prev-more"
                          key="btn-prev-more"
                          path={this.props.path}
                          isHidden={this.isPrevMoreHidden()}>{labels('prevSet')}</Page>

                    {this.renderPages( this.visibleRange() )}

                    <Page className="btn-next-more"
                          key="btn-next-more"
                          path={this.props.path}
                          isHidden={this.isNextMoreHidden()}>{labels('nextSet')}</Page>

                    <Page className="btn-next-page"
                          key="btn-next-page"
                          path={this.props.path}
                          isDisabled={this.isNextDisabled()}
                          pageNumber={this.getNextPage()}>{labels('next')}</Page>
                </ul>
            </nav>
        );
    },

    getRange: function( start, end ){
      var res = [];
      for ( var i = start; i < end; i++ ) {
          res.push( i );
      }
      return res; 
    },

    renderPages: function(pair){
        var self = this;
        
        return this.getRange( pair[0], pair[1] ).map(function ( el, idx ) {
            var current = el
              , isActive = (self.props.current === current);

            return (<Page key={idx} path={self.props.path} isActive={isActive} pageNumber={el} className="btn-numbered-page">{el}</Page>);
        });
    }
});

var Page = React.createClass({
    render: function () {
        var props = this.props;

        if ( props.isHidden ) return null;

        var baseCss = props.className ? props.className + ' ' : ''
          , css     = baseCss
                      + (props.isActive ? 'active' : '')
                      + (props.isDisabled ? ' disabled' : '');

        return (
            <li key={this.props.key} className={css}>
                <a href={this.props.path+"?page="+this.props.pageNumber}>{this.props.children}</a>
            </li>
        );
    }
});    
