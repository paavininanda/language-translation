@UsersShowBox = React.createClass
  getInitialState: ->
    current_user_roles: @props.current_user_roles
    user: @props.user
    user_roles: @props.user_roles
    organization: @props.organization
  handleAdminToggle: (userdata) ->
    grant_url = '/members/grant_admin.json'
    revoke_url = '/members/revoke_admin.json'
    if userdata.action == 'grant'
      $.ajax({
        url: grant_url
        dataType: 'json'
        type: 'POST'
        data: {user_id: userdata.user_id}
        success: ((data) ->
          @setState({user_roles: data.users})).bind(this)
        error: ((xhr, status, err) ->
          console.error(grant_url, status, err.toString())).bind(this)
      })
    else if userdata.action== 'revoke'
      $.ajax({
        url: revoke_url
        dataType: 'json'
        type: 'POST'
        data: {user_id: userdata.user_id}
        success: ((data) ->
          @setState({user_roles: data.users})).bind(this)
        error: ((xhr, status, err) ->
          console.error(revoke_url, status, err.toString())).bind(this)
      })
  render: ->
    current_user_roles = @state.current_user_roles
    user = @state.user
    user_roles = @state.user_roles
    organization = @state.organization
    gender = ''
    memberEditUrl = "/members/" + @state.user.id + "/edit"

    login_approval_message =
      if user.login_approval_at then ''
      else 'The user first needs to be approved to use the account.'
    clickToggle = @handleAdminToggle

    `<div>
      <header className="app-bar promote-layer">
       <div className="app-bar-container">
         <button className="menu"><span className="icon-menu"></span></button>
         
         <div className="Heading">
            <a href="/members/" className="Back">
              <span className="icon-chevron-left-thin"></span><span className="Back-text">Back</span>
            </a>
           <h1 className="title"><span>Member</span></h1>
         </div>
       </div>
      </header>

      <main className="UsersShowBox">
        <div className="Form u-pushTopBottom clear">
          <div className="g--half">
            <h3 className="title">Member #{user.id}</h3>

            <dl className="Info">
              <dt>Organization</dt>
              <dd>{organization.name} <a href={memberEditUrl} className="Info-more">Edit</a></dd>

              <dt>Name</dt>
              <dd>{user.first_name} {user.last_name}</dd>

              <dt>Username</dt>
              <dd>{user.username}</dd>

              <dt>Email</dt>
              <dd>{user.email}</dd>

              <dt>Location</dt>
              <dd>{user.location || "N/A"}</dd>

              <dt>Language</dt>
              <dd>{user.lang || "N/A"}</dd>

              <dt>Contact Number</dt>
              <dd>{user.contact || "N/A"}</dd>
            </dl>
          </div>

          <div className="g--half g--last">
            <dl class="Info">
            </dl>
            <p className="text-center"><strong>{login_approval_message}</strong></p>
            <ToggleAdminButton current_user_roles={current_user_roles} user={user} user_roles={user_roles} onToggleAdmin={clickToggle} />
          </div>

        </div>
    </main>
    </div>`


@ToggleAdminButton = React.createClass
  getInitialState: ->
    { showModal: false }
  closeModal: ->
    @setState({ showModal: false })
  openModal: ->
    @setState({ showModal: true })
  handleToggle: ->
    @closeModal()
    if ('admin' in @props.user_roles)
      @props.onToggleAdmin({user_id: @props.user.id, action: 'revoke'})
    else
      @props.onToggleAdmin({user_id: @props.user.id, action: 'grant'})
  render: ->
    current_user_roles = @props.current_user_roles
    user_roles = @props.user_roles
    button_message =
      if ('admin' in user_roles) then 'Revoke Admin Rights'
      else 'Make Admin'
    modal_message =
      if ('admin' in user_roles) then "Do you really want to revoke admin rights from '" + @props.user.username + "'?"
      else "Do you really want to promote '" + @props.user.username + "' as an admin?"
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
          <Button onClick={this.handleToggle} bsStyle='primary'>Yes</Button>
        </Modal.Footer>
      </Modal>`

    if ('admin' in current_user_roles or 'superadmin' in current_user_roles)
      `<p className='text-center'>
        <Button onClick={this.openModal}>{button_message}</Button>
        {modal}
      </p>`
    else
      ``
