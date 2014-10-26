React = require 'react'
qwest = require '../lib/qwest.js'
Loading = require './Loading.cjsx'
OAuth = require './OAuth.coffee'


EditorView = module.exports = React.createClass
  displayName: 'EditorView'

  propTypes:
    params: React.PropTypes.shape
      username: React.PropTypes.string.isRequired
      repo: React.PropTypes.string.isRequired
      sha: React.PropTypes.string.isRequired

  getInitialState: ->
    loading: true
    error: null
    html: null

  componentDidMount: ->
    qwest.get 'https://api.github.com/repos/'+@props.params.username+'/'+@props.params.repo+'/git/blobs/'+@props.params.sha + OAuth.queryString()
      .success (response) =>
        fixedBase64 = response.content.replace /\n/g, ''
        @setState
          loading: false
          html: atob(fixedBase64)
      .error (err) =>
        console.error err
        @setState
          loading: false
          error: err

  render: ->
    <div>
    <h2>EditorView</h2>
    <div>
    <Loading loading={@state.loading} error={@state.error} errorMessage="Error loading file. Please try again in a few minutes.">
      <textarea style={{width:'100%',height:'40em'}} defaultValue={@state.html} />
    </Loading>
    </div>
    </div>