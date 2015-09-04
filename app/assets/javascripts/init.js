 $(document).ready(function() {
        $( "#workspace" ).workspace();
        workspace = $( "#workspace" ).workspace("instance");
        workspace.delegate = new Repository("http://localhost:3000/api/documents");
        setTimeout(function(){
           window.ace.config.set("basePath", "assets/workspace/src/ace-build")
         },1000)
        $("#addTab").click(function(){
          //require("ace/ext/language_tools");
         
          workspace.open("","",AceWorkspaceEditor,{ace:window.ace,mode:"ace/mode/cql"})
        });

        $.get("/api/documents").then( function (data) {
          treejson = []
          for (var key in data){
            treejson.push({"id": key, "parent": "#", "text": key})
            for (var i = 0; i < data[key].length; i++){
              if(data[key][i]) {
                treejson.push({"id": key+"/"+data[key][i], "parent": key, "text": data[key][i]})
              }
            }
          }

          $('#jstree').jstree({"core": {
              "data": treejson
            }
          }).bind("select_node.jstree", function(e, data) {
            filename = data.selected[0]
            if(data.node.children.length == 0){
              $.get("/api/documents/" + filename).then( function (resp) {
                var tabs = workspace.tabs.tabs("instance").tabs
                for(var i = 0; i < tabs.length; i++) {
                  if($(tabs[i]).data().editor.name == filename) {
                    workspace.tabs.tabs("option", "active", i);
                    return;
                  }
                }
                window.ace.config.set("basePath", "assets/workspace/src/ace-build")
                workspace.open(data.selected[0], resp, AceWorkspaceEditor,{ace:window.ace,mode:"ace/mode/cql"})
              });
            }
          });
        });
       }
      );


  //dom ready handler so that the script is executed after the dom is loaded
   jQuery(function () {
    //register the click handler to an element with id mybutton
    $('#mybutton').click(function () {
        $("#panel").toggle("slide");
    });

    $(function() {
      $( "#menu" ).menu({
        position: {
          my:'left+10 bottom-15',
          at:'left center'
         },
        select: function(event,ui){
          var command = menuCommands[ui.item[0].id]
          if(command){
            command();
          }
        }
      });    
    });

        var menuCommands = {}
    menuCommands["new"] = function(){
        workspace.open("","",AceWorkspaceEditor,{ace:window.ace,mode:"ace/mode/cql"})
    }

    menuCommands["close"] = function(){
       var active =  workspace.activeEditor();
       if(active){
        active.close();
       }
    }

    menuCommands["closeAll"] = function(){
       workspace.closeAll();
    }

    menuCommands["closeOthers"] = function(){
       var active =  workspace.activeEditor();
       if(active){
         workspace.closeOthers(active)
       }
    }
    menuCommands["refresh"] = function(){
       var active =  workspace.activeEditor();
       if(active){
         active.$aceSession.document.setValue(active.$originalContent)
       }
    }

    menuCommands["print"] = function(){
      var active =  workspace.activeEditor();
      if(active){
        var editor = active.$aceEditor
        require("ace/config").loadModule("ace/ext/static_highlight", function(m) {
        var result = m.renderSync(
            editor.getValue(), editor.session.getMode(), editor.renderer.theme
        )
        document.body.style.display="none"
        var d = document.createElement("div")
        d.innerHTML=result.html
        document.documentElement.appendChild(d)
        require("ace/lib/dom").importCssString(result.css)

        setTimeout(function() {window.print()}, 10)

        window.addEventListener("focus", function restore() {
           window.removeEventListener("focus", restore, false)
          d.parentNode.removeChild(d)
          document.body.style.display= ""
          editor.resize(true)
        }, false)
       })
      }
  }

})