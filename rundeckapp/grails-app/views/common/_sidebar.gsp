%{--
  - Copyright 2016 SimplifyOps, Inc. (http://simplifyops.com)
  -
  - Licensed under the Apache License, Version 2.0 (the "License");
  - you may not use this file except in compliance with the License.
  - You may obtain a copy of the License at
  -
  -     http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS,
  - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  - See the License for the specific language governing permissions and
  - limitations under the License.
  --}%

<%@ page import="com.opensymphony.module.sitemesh.RequestConstants; com.dtolabs.rundeck.server.authorization.AuthConstants" %>
<g:set var="selectParams" value="${[:]}"/>
<g:set var="buildIdent" value="${servletContextAttribute(attribute: 'app.ident')}"/>
<g:set var="appId" value="${g.appTitle()}"/>
<g:if test="${pageScope._metaTabPage && pageScope._metaTabPage != 'configure'&& pageScope._metaTabPage != 'projectconfigure'}">
    <g:set var="selectParams" value="${[page: _metaTabPage,project:params.project?:request.project]}"/>
</g:if>

<div class="logo">
    <a href="${grailsApplication.config.rundeck.gui.titleLink ? enc(attr:grailsApplication.config.rundeck.gui.titleLink) : g.createLink(uri: '/')}"
       title="Home">
        <g:set var="appTitle"
               value="${grailsApplication.config.rundeck?.gui?.title ?: g.message(code: 'main.app.name',default:'')}"/>
        <g:set var="appDefaultTitle" value="${g.message(code: 'main.app.default.name',default:'')}"/>
        <g:set var="brandHtml"
               value="${grailsApplication.config.rundeck?.gui?.brand?.html ?: g.message(code: 'main.app.brand.html',default:'')}"/>
        <g:set var="brandDefaultHtml"
               value="${g.message(code: 'main.app.brand.default.html',default:'')}"/>
        <i class="rdicon app-logo"></i>
        <g:if test="${brandHtml}">
            ${enc(sanitize:brandHtml)}
        </g:if>
        <g:elseif test="${appTitle}">
            ${appTitle}
        </g:elseif>
        <g:elseif test="${brandDefaultHtml}">
            ${enc(sanitize:brandDefaultHtml)}
        </g:elseif>
        <g:else>
            ${appDefaultTitle}
        </g:else>
    </a>
</div>

<g:set var="selectedclass" value="active"/>

<g:set var="wfselected" value=""/>
<ul class="nav">
<g:if test="${request.getAttribute(RequestConstants.PAGE)}">
    <g:ifPageProperty name='meta.tabpage'>
        <g:ifPageProperty name='meta.tabpage' equals='jobs'>
            <g:set var="wfselected" value="${selectedclass}"/>
        </g:ifPageProperty>
    </g:ifPageProperty>
    <g:set var="resselected" value=""/>
    <g:ifPageProperty name='meta.tabpage'>
        <g:ifPageProperty name='meta.tabpage' equals='nodes'>
            <g:set var="resselected" value="${selectedclass}"/>
        </g:ifPageProperty>
    </g:ifPageProperty>
    <g:set var="adhocselected" value=""/>
    <g:ifPageProperty name='meta.tabpage'>
        <g:ifPageProperty name='meta.tabpage' equals='adhoc'>
            <g:set var="adhocselected" value="${selectedclass}"/>
        </g:ifPageProperty>
    </g:ifPageProperty>
    <g:set var="eventsselected" value=""/>
    <g:ifPageProperty name='meta.tabpage'>
        <g:ifPageProperty name='meta.tabpage' equals='events'>
            <g:set var="eventsselected" value="${selectedclass}"/>
        </g:ifPageProperty>
    </g:ifPageProperty>
</g:if>
<g:if test="${params.project ?: request.project}">
    <li class="${enc(attr: wfselected)}">
        <g:link controller="menu" action="jobs" class=" toptab ${enc(attr: wfselected)}" params="[project: params.project ?: request.project]">
            <p>
              <g:message code="gui.menu.Workflows"/>
            </p>
        </g:link>
    </li>
    <li class="${enc(attr:resselected)}">
        <g:link controller="framework" action="nodes" class=" toptab ${enc(attr: resselected)}" params="[project: params.project ?: request.project]">
            <p>
              <g:message code="gui.menu.Nodes"/>
            </p>
        </g:link>
    </li>
    <g:if test="${auth.adhocAllowedTest(action: AuthConstants.ACTION_RUN, project: params.project ?: request.project)}">
        <li class="${enc(attr: adhocselected)}">
            <g:link controller="framework" action="adhoc" class=" toptab ${enc(attr: adhocselected)}" params="[project: params.project ?: request.project]">
                <p>
                  <g:message code="gui.menu.Adhoc"/>
                </p>
            </g:link>
        </li>
    </g:if>
    <li class="${enc(attr: eventsselected)}">
      <g:link controller="reports" action="index" class=" toptab ${enc(attr: eventsselected)}" params="[project: params.project ?: request.project]">
        <p>
          <g:message code="gui.menu.Events"/>
        </p>
      </g:link>
    </li>
    <g:set var="projConfigAuth"
           value="${auth.resourceAllowedTest(
                   type: AuthConstants.TYPE_PROJECT,
                   name: (params.project ?: request.project),
                   action: [AuthConstants.ACTION_CONFIGURE,
                            AuthConstants.ACTION_ADMIN,
                            AuthConstants.ACTION_IMPORT,
                            AuthConstants.ACTION_EXPORT,
                            AuthConstants.ACTION_DELETE],
                   any: true,
                   context: 'application'
           )}"/>
    <g:set var="projACLAuth"
           value="${auth.resourceAllowedTest(
                   type: AuthConstants.TYPE_PROJECT_ACL,
                   name: (params.project ?: request.project),
                   action: [AuthConstants.ACTION_READ,
                            AuthConstants.ACTION_ADMIN],
                   any: true,
                   context: 'application'
           )}"/>

    <g:if test="${projConfigAuth||projACLAuth}">
        <li class="dropdown ${enc(attr: projconfigselected)}" id="projectAdmin">
            <bs:dropdownToggle css="toptab ${projconfigselected}">
                <p>
                  <g:message code="Project"/>
                </p>
                <g:if test="${request.getAttribute(RequestConstants.PAGE)}">
                    <g:ifPageProperty name='meta.projtabtitle'>
                        <g:icon name="menu-right"/>
                        <g:pageProperty name='meta.projtabtitle'/>
                    </g:ifPageProperty>
                </g:if>
            </bs:dropdownToggle>
            <g:render template="/menu/projectConfigNavMenu"/>
        </li>
    </g:if>
</g:if>
  <li class="snapshot-version">
    <span class="rundeck-version-identity"
          data-version-string="${enc(attr: buildIdent)}"
          data-version-date="${enc(attr: servletContextAttribute(attribute: 'version.date_short'))}"
          data-app-id="${enc(attr: appId)}"></span>
    <g:link controller="menu" action="welcome" class="version link-bare">
        <g:appTitle/> ${buildIdent}
    </g:link>
  </li>
</ul>

<g:if test="${request.getAttribute(RequestConstants.PAGE)}">
    <g:ifPageProperty name='meta.tabtitle'>
        <ul class="nav">
            <li class="active">
                <a href="">
                    <g:icon name="menu-right"/>
                    <g:pageProperty name='meta.tabtitle'/>
                </a>
            </li>
        </ul>
    </g:ifPageProperty>
</g:if>
<g:if test="${session?.user && request.subject }">
    <g:ifExecutionMode passive="true">
        <p class="navbar-text has_tooltip navbar-text-warning"
           title="${g.message(code:'system.executionMode.description.passive')}"
           data-toggle="tooltip"
           data-placement="bottom"
        >
            <i class="glyphicon glyphicon-exclamation-sign"></i>
            <g:message code="passive.mode" />
        </p>
        <auth:resourceAllowed action="${[AuthConstants.ACTION_ENABLE_EXECUTIONS,AuthConstants.ACTION_ADMIN]}" any="true" context="application" kind="system">
            <g:form class="navbar-form navbar-left" controller="execution" action="executionMode" method="POST" useToken="true">
                <g:hiddenField name="mode" value="active"/>
                <g:hiddenField name="project" value="${params.project}"/>
                <g:link action="executionMode"
                        controller="menu"
                        class="btn btn-default "
                        title="${message(code:"action.executionMode.set.active.help")}"
                >
                    Change
                </g:link>
            </g:form>
        </auth:resourceAllowed>
    </g:ifExecutionMode>
</g:if>