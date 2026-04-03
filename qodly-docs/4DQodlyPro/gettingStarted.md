---
id: gettingStarted
title: Welcome
---

**Qodly Studio** is an interface builder for web applications. It provides developers with a graphical page editor to design applications running in web browsers or smartphones. It supports natively the [ORDA objects](https://developer.4d.com/docs/ORDA/overview).

You use Qodly Studio directly from your [**4D environment**](https://developer.4d.com/docs) to build modern and sophisticated interfaces that you can easily integrate to and [deploy](../4DQodlyPro/deploy.md) with your existing 4D projects.

Qodly Studio proposes a full-featured web UI, allowing you to:

- create Qodly pages by placing components on a canvas
- map components to Qodly Sources
- trigger 4D code by configuring events
- and much more.


## Configuration

### Requirements

#### Browser

Qodly Studio supports the following web browsers:

- Chrome
- Edge
- FireFox

The recommended resolution is 1920x1080.


#### Project

Qodly Studio only works with 4D [projects](https://developer.4d.com/docs/Project/overview) (binary databases are not supported).

- Web sessions (*aka* Scalable sessions) must [be enabled](https://developer.4d.com/docs/WebServer/sessions#enabling-web-sessions).
- The ["forceLogin" mode](https://developer.4d.com/docs/REST/authUsers#force-login-mode) must be [activated](https://developer.4d.com/docs/settings/web#activate-rest-authentication-through-dsauthentify-function) to handle web sessions.
- The 4D code called by Qodly forms must be [thread-safe](https://developer.4d.com/docs/WebServer/preemptiveWeb).


#### Web Server & WebAdmin Server

Qodly Studio is served by the [WebAdmin web server](https://developer.4d.com/docs/Admin/webAdmin) and access data from 4D projects exposed as [REST servers](https://developer.4d.com/docs/REST/configuration) and handled by the [4D web server](https://developer.4d.com/docs/WebServer/overview). **All these servers must be launched**. If one of these levels are not enabled, access to Qodly Studio is denied (a 403 page is returned).



You need to [**enable access to Qodly Studio** on the WebAdmin web server](https://developer.4d.com/docs/Admin/webAdmin#enable-access-to-qodly-studio). This setting applies to the 4D application (4D or 4D Server) on the host machine. All projects opened with that 4D application take this setting into account.

In addition, you need to explicitly designate every project that can be accessed. The **Enable access to Qodly Studio** option must be enabled on the [Web Features page of the 4D application's Settings](https://developer.4d.com/docs/settings/web#enable-access-to-qodly-studio). Keep in mind that [user settings](https://developer.4d.com/docs/settings/overview) can be defined at several levels, and that priorities apply.


### One-click configuration

All the [configuration requirements](#requirements) can be automatically set for you in one click when you select the **Qodly Studio...** menu command from the **Design** menu in 4D single-user for the first time. Any requirements that are not met are listed in a dialog box and will be automatically adjusted if you click the **Enable settings** button. 


:::note

- Only settings that need to be edited are listed in the dialog box. 
- Since scalable sessions run in preemptive mode, enabling this setting might require that you evaluate the [thread-safety property](https://developer.4d.com/docs/Develop/preemptive-processes#writing-a-thread-safe-method) of your code. 
- Activating the "forceLogin" mode might require that you reconfigure the REST accesses, [as explained in this blog post](https://blog.4d.com/force-login-becomes-default-for-all-rest-auth/). 
- If 4D's [user settings](https://developer.4d.com/docs/settings/overview#enabling-user-settings) are enabled, pay attention to the fact that active settings will be configured.

:::


### Activating authentication

Authentication on the WebAdmin web server is granted using an access key. For more details, see [Access key](https://developer.4d.com/docs/Admin/webAdmin#access-key).

In case of [access through 4D](#from-the-4d-application), an access key is transparently provided.  


### Development and deployment

In accordance with the management of 4D projects, only the following usages are supported:

- development with Qodly Studio must be done using **4D** (single-user).
- deployment of 4D applications powered with Qodly pages must be done using **4D Server**.

:::warning

You can open Qodly Studio, [debug](#using-qodly-debugger-on-4d-server) and edit Qodly pages directly on a 4D Server machine when a project is running in interpreted mode. This feature is only provided for testing and debugging purposes, for example to evaluate the application flow with actual data, or in multi-user environment. It must NOT be considered as a regular way to develop applications since it does not provide any control over concurrent accesses.

:::



## Opening Qodly Studio

The Qodly Studio page is available when [all requirements](#requirements) are met.

There are two ways to access Qodly Studio:

- by selecting the **Qodly Studio...** menu command from your 4D application,
- by entering directly an url in a browser. 

### From a 4D application

Select the **Qodly Studio...** menu command from the **Design** menu (4D single-user) or the **Window** menu (4D Server).

Depending on the WebAdmin web server configuration, your default browser opens at `IPaddress:HTTPPort/studio` or `IPaddress:HTTPSPort/studio`. 

:::note

When opening Qodly Studio from your 4D single-user application for the first time, you can benefit from the [one-click configuration dialog box](#one-click-configuration) to automatically configure all necessary settings.

:::



### On a browser

When opening Qodly Studio on a browser, you need to make sure all necessary [requirements](#requirements) have been configured. 

with the WebAdmin web server running (launched from 4D or 4D Server), enter the following address:

```
IPaddress:HTTPPort/studio
```
or:

```
IPaddress:HTTPSPort/studio
```

For example, after launching a local web server on port 7080, type this address in your browser:

`localhost:7080/studio`

You will then be prompted to enter the [access key](https://developer.4d.com/docs/Admin/webAdmin#access-key) to access Qodly Studio.



## Developing with Qodly Studio

### Language

The following commands and classes are dedicated to the server-side management of Qodly pages:

- [`Web Form`](../QodlyinCloud/qodlyScript/commands/webForm.md) command: returns the Qodly page as an object.
- [`Web Event`](../QodlyinCloud/qodlyScript/commands/webEvent.md) command: returns events triggered within Qodly page components.
- [`WebForm`](../QodlyinCloud/qodlyScript/WebFormClass.md) class: functions and properties to manage the rendered Qodly page.
- [`WebFormItem`](../QodlyinCloud/qodlyScript/WebFormItemClass.md) class: functions and properties to manage Qodly page components.


### Using project methods

We recommend using class functions over project methods. Only class functions can be called from [components](../4DQodlyPro/pageLoaders/components/componentsBasics.md). However, you can still use your project methods in Qodly Studio in two ways:

- You can call your methods from class functions.
- You can directly [execute your methods](../4DQodlyPro/coding.md#method-and-function-management) from the Qodly Explorer.


### Offline use

You can develop with Qodly Studio while your computer is not connected to the internet. In this case however, the following features are not available:

- [Templates](../4DQodlyPro/pageLoaders/templates.md): the Template library is empty





## Enabling rendering

Qodly Studio encapsulates Qodly pages, including layout, data connections, and event-driven logic, in a structured JSON file. This JSON file is processed on-the-fly by the **Qodly renderer** to serve a fully functional web page.

:::info

See [this section](../4DQodlyPro/rendering.md) for detailed information on how to render Qodly pages in Qodly.

:::

To enable the rendering of Qodly pages, the following options must be set.

* The 4D project's **Settings** > **Web** > **Web Features** > [**Expose as REST server**](https://developer.4d.com/docs/19/REST/configuration#starting-the-rest-server) option must be activated.
* The [4D web server](https://developer.4d.com/docs/WebServer/overview) must be running.

:::note

[Renderer buttons](../4DQodlyPro/rendering.md#page-rendering-options) are not available if the configuration options are not activated.

:::

### Scope of Qodly forms

When rendering Qodly forms in the Qodly Studio, the renderer will connect to the 4D web server through HTTP or HTTPS, depending on the settings, following the same HTTP/HTTPS connection pattern as for the [4D WebAdmin web server](https://developer.4d.com/docs/Admin/webAdmin#accept-http-connections-on-localhost). See also [this paragraph](#about-license-usage-for-rendering) about URL schemes and license usage.


Keep in mind that Qodly Studio runs through the 4D WebAdmin web server. When you use Qodly Studio as a developer, even when you preview a Qodly Page in the studio, you're using the 4D WebAdmin web server. This allows you to see dataclasses, functions and attributes that are not exposed as REST resources for example (they are greyed out).

However, page rendering happens outside Qodly Studio, and is served by the standard 4D web server. In this situation, your web application cannot access assets that are not exposed as REST resources. See [Exposed vs non-exposed functions](https://developer.4d.com/docs/ORDA/ordaClasses#exposed-vs-non-exposed-functions) and [Exposing tables](https://developer.4d.com/docs/REST/configuration#exposing-tables) for more information on how to expose assets.




### Accessing Qodly pages

For deployment, the WebAdmin server is not necessary. End-user access to your web application made with Qodly Studio is based on the 4D REST protocol, and as such, it works as through a conventional 4D remote application.

Your Qodly pages are available through the following url:

```
IP:port/$lib/renderer/?w=QodlyPageName
```

...where *IP:port* represents the address of the web server and *QodlyPageName* is the name of the Qodly page.  

For example:

```
https://www.myWebSite.com/$lib/renderer/?w=welcome
```

### Preview Qodly Application

You can preview your Qodly application at any moment by selecting the **Preview Qodly Application...** command in the **Windows** menu (4D Server) or in the **Design** menu (4D single-user). 

This command launches the Qodly renderer on a local address in your default browser and displays the **start page** [defined in the Application settings](https://developer.qodly.com/docs/studio/settings#start-page) of Qodly Studio.


