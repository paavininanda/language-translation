@UsersIndexBox = React.createClass
  getInitialState: ->
    users: @props.users
    organizations: @props.organizations
    admins: @props.admins
    volunteers: @props.volunteers
    contributors: @props.contributors
    current_user: @props.current_user
  handleUserApproval: (userdata) ->
    approveurl = 'members/approve.json'
    disapproveurl = 'members/disapprove.json'
    if userdata.action == 'approve'
      $.ajax({
        url: approveurl
        dataType: 'json'
        type: 'POST'
        data: {user_id: userdata.user_id}
        success: ((data) ->
          @setState({users: data.users})).bind(this)
        error: ((xhr, status, err) ->
          console.error(approveurl, status, err.toString())).bind(this)
      })
    else if userdata.action == 'disapprove'
      $.ajax({
        url: disapproveurl
        dataType: 'json'
        type: 'POST'
        data: {user_id: userdata.user_id}
        success: ((data) ->
          @setState({users: data.users})).bind(this)
        error: ((xhr, status, err) ->
          console.error(disapproveurl, status, err.toString())).bind(this)
      })
  render: ->
    users = @state.users
    organizations = @state.organizations
    admins = @state.admins
    volunteers = @state.volunteers
    contributors = @state.contributors
    current_user = @state.current_user
    button =
      `<div className="AppControls">
	<div className="AppControls--box AppControls-right">
            <a className="button--icontext button--ricontext" href="/members/new"><i className="icon-plus"></i> <span>New Member</span></a>
        </div>
      </div>` if current_user in admins
     `<div>
      	<header className="app-bar promote-layer">
       <div className="app-bar-container">
         <button className="menu"><span className="icon-menu"></span></button>
         
         <div className="Heading">
           <h1 className="title"><span>Members</span></h1>
         </div>
       </div>
      </header>

      <main className="UsersIndexBox">
        <div className="AppControls">
         <div className="AppControls--box AppControls-middle"></div>
	 <div> {button} </div>
         </div>

        <UsersIndexList users={users} current_user={current_user} organizations={organizations} admins={admins} volunteers={volunteers}
          contributors={contributors} onUserApproval={this.handleUserApproval}/>
      </main>
    </div>`
@UsersIndexList = React.createClass
  handleApproval: (data) ->
    @props.onUserApproval(data)
  render: ->
    clickApproval = @handleApproval
    organizations = @props.organizations
    admins = @props.admins
    volunteers = @props.volunteers
    contributors = @props.contributors
    current_user = @props.current_user
    userNodes = @props.users.map((user) ->
      organization = organizations[user.organization_id - 1]
      role =
        if (user.id in admins) then 'Admin'
        else if (user.id in volunteers) then 'Volunteer'
        else if (user.id in contributors) then 'Contributor'
        else 'Guest'
      `<UserNode key={user.id} user={user} admins={admins} volunteers={volunteers} current_user={current_user} organization={organization} role={role} onUserApproval={clickApproval}/>`)

    `<div className="CardListTable">
      <ul className="CardListTable-body">
        {userNodes}
      </ul>
    </div>`


@UserNode = React.createClass
  getInitialState: ->
    showModal: false
  closeModal: ->
    @setState({ showModal: false })
  openModal: ->
    @setState({ showModal: true })
  handleApproval: ->
    @closeModal()
    user = @props.user
    if user.login_approval_at
      @props.onUserApproval({user_id: user.id, action: 'disapprove'})
    else
      @props.onUserApproval({user_id: user.id, action: 'approve'})
  render: ->
    organizations = @props.organizations
    admins = @props.admins
    volunteers = @props.volunteers
    contributors = @props.contributors
    current_user = @props.current_user
    modal_message =
      if @props.user.login_approval_at
        "Are you sure that you want to disapprove '" + @props.user.username + "' from signing in?"
      else
        "Are you sure that you want to approve '" + @props.user.username + "' to sign in?"
    modal =
      `<Modal show={this.state.showModal} onHide={this.closeModal}>
        <Modal.Header closeButton>
          Are you sure?
        </Modal.Header>
        <Modal.Body>
          {modal_message}
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.closeModal}>No</Button>
          <Button onClick={this.handleApproval} bsStyle='primary'>Yes</Button>
        </Modal.Footer>
      </Modal>`

    login_approval =
      if @props.user.login_approval_at
        `<div>
          {this.props.user.login_approval_at.slice(0,10)}
          <button onClick={this.openModal} className='btn btn-default'>
            <span className='glyphicon glyphicon-remove' />
          </button>
          {modal}
        </div>`
      else
        `<div>
          Waiting
          <button onClick={this.openModal} className='btn btn-default'>
            <span className='glyphicon glyphicon-ok' />
          </button>
          {modal}
        </div>`

    show_url = "/members/" + @props.user.id

    buttons=
        `<li className="CardListTable-cal u-w80px" data-th="Approval/Disapproval">
          <div className="CardListTable-content">
            {login_approval}
          </div>
         </li>` if current_user in admins
    

    organization_name = @props.organization.name if @props.organization
    `<li>
      <ul className="CardListTableRow">
        <li className="CardListTable-cal u-w100px" data-th="Name">
          <div className="CardListTable-content">
            <a href={show_url}>{this.props.user.first_name} {this.props.user.last_name}</a>
          </div>
        </li>
        <li className="CardListTable-cal u-w100px" data-th="Organization">
          <div className="CardListTable-content">
            {organization_name} 
         </div>
        </li>
        <li className="CardListTable-cal u-w100px" data-th="Email">
          <div className="CardListTable-content">
            {this.props.user.email}
          </div>
        </li>
        <li className="CardListTable-cal u-w80px" data-th="Location">
          <div className="CardListTable-content">
            {this.props.user.location}
          </div>
        </li>
        <li className="CardListTable-cal u-w80px" data-th="Contact">
          <div className="CardListTable-content">
            {this.props.user.content}
          </div>
        </li>
        <li className="CardListTable-cal u-w80px" data-th="Role">
          <div className="CardListTable-content">
            {this.props.role}
              <a className="btn btn-default" href="/sites"><i className="glyphicon glyphicon-plus"></i></a>
       
 
          </div>
        </li>
     
          {buttons}
     
      </ul>
     </li>`
     
      
    
