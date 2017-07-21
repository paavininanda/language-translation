@Assign = React.createClass
  getInitialState: ->
    site: @props.site
    country: @props.country
    volunteers: @props.volunteers
    contributors: @props.contributors
   
  handleVolunteerAddition: (userdata) ->
    userdata.act = "volunteer"
    userdata.site_id = @state.site.id
    add_role_url = '/sites/add_role.json'
    $.ajax({
      url: add_role_url
      dataType: 'json'
      type: 'POST'
      data: userdata
      success: ((data) ->
        @setState({volunteers: data.sites}) #'data' is in form {sites: Array[n]}
      ).bind(this)
      error: ((xhr, status, err) ->
        @handleAlertShow()
        console.error(add_role_url, status, err.toString())
      ).bind(this)
    })
  handleContributorAddition: (userdata) ->
    userdata.act = "contributor"
    userdata.site_id = @state.site.id
    add_role_url = '/sites/add_role.json'
    $.ajax({
      url: add_role_url
      dataType: 'json'
      type: 'POST'
      data: userdata
      success: ((data) ->
        @setState({contributors: data.sites}) #'data' is in form {sites: Array[n]}
      ).bind(this)
      error: ((xhr, status, err) ->
        @handleAlertShow()
        console.error(add_role_url, status, err.toString())
      ).bind(this)
    })

  render: ->
      `<div>
      <header className="app-bar promote-layer">
        <div className="app-bar-container">
          <button className="menu"><span className="icon-menu"></span></button>
          <div className="Heading">
            <a href="/sites" className="Back"><span className="icon-chevron-left-thin"></span><span className="Back-text">Back</span></a>
            <h1 className="title"><span>Post</span></h1>
          </div>
        </div>
      </header>
      <main>
        <div className="SitesShowBox">
          <h1>{this.state.site.name} <span className="h4">{this.state.country.name}</span></h1>
          <br/>
            <VolunteersList data={this.state.volunteers} onRoleAddition={this.handleVolunteerAddition}/>
          <ContributorsList data={this.state.contributors} onRoleAddition={this.handleContributorAddition}/>
        </div>
       </main>
     </div>`

@VolunteersList = React.createClass
  handleRoleAddition: ->
    @props.onRoleAddition({username: React.findDOMNode(@refs.username).value.trim(), action: "", site_id: -1})
    React.findDOMNode(@refs.username).value = ''
  handleRoleRemoval: (data) ->
    data.act = 'volunteer'
    @props.onRoleRemoval(data)
  render: ->
    clickRemoval = @handleRoleRemoval
    `<div className="VolunteersList">
      <h2>Volunteers</h2>
      <ul>
       
        <div className="col-md-5">
          <div className="input-group">
            <input type="text" className="form-control" placeholder="New volunteer's username" ref='username'/>
            <span className="input-group-btn">
              <button onClick={this.handleRoleAddition} className="btn btn-default" type="button">Add!</button>
            </span>
          </div>
        </div>
        <br/><br/>
      </ul>
    </div>`

@ContributorsList = React.createClass
  handleRoleAddition: ->
    @props.onRoleAddition({username: React.findDOMNode(@refs.username).value.trim(), act: "", site_id: -1})
    React.findDOMNode(@refs.username).value = ''
  handleRoleRemoval: (data) ->
    data.act = 'contributor'
    @props.onRoleRemoval(data)
  render: ->
    clickRemoval = @handleRoleRemoval
    `<div className="ContributorsList">
      <h2>Contributors</h2>
      <ul>
       
        <div className="col-md-5">
          <div className="input-group">
            <input type="text" className="form-control" placeholder="New contributor's username" ref='username'/>
            <span className="input-group-btn">
              <button onClick={this.handleRoleAddition} className="btn btn-default" type="button">Add!</button>
            </span>
          </div>
        </div>
        <br/><br/>
      </ul>
    </div>`





