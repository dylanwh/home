function fish_prompt --description 'Write out the prompt'
  set -l last_status $status
  set -l normal (set_color normal)

  # Hack; fish_config only copies the fish_prompt function (see #736)
  if not set -q -g __fish_classic_git_functions_defined
    set -g __fish_classic_git_functions_defined

    function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_vcs --on-variable fish_color_vcs --description "Event handler; repaint when fish_color_vcs changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_bind_mode --on-variable fish_key_bindings --description "Event handler; repaint when fish_key_bindings changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    # initialize our new variables
    if not set -q __fish_classic_git_prompt_initialized
      set -qU fish_color_user
      or set -U fish_color_user -o green
      set -qU fish_color_host
      or set -U fish_color_host -o cyan
      set -qU fish_color_status
      or set -U fish_color_status red
      set -qU fish_color_vcs
      or set -U fish_color_vcs -b yellow
      set -U __fish_classic_git_prompt_initialized
    end
  end
  
  set -l suffix
  set -l prompt_status
  if test $last_status -ne 0
    set prompt_status (set_color $fish_color_status) "$last_status" "$normal"
    set suffix "?"
  else
    set suffix "%"
  end

  set -l vcs_color (set_color $fish_color_vcs)(set_color black)
  set -l my_fish_vcs_prompt \
    (string replace -ar '\((.+)\)' "[$vcs_color\${1}$normal]" (__fish_vcs_prompt))

  test -n "$SSH_CLIENT"
  and echo -n -s "$USER" $normal @ (prompt_hostname) ' '
  echo -n -s (set_color $fish_color_cwd) (prompt_pwd) $normal
  echo -n -s $my_fish_vcs_prompt $normal " " $prompt_status $normal $suffix " "
end
