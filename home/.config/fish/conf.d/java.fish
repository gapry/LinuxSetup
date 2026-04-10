set -gx JAVA_HOME (cs java-home --jvm temurin:1.25.0.2)

if test -d "$JAVA_HOME/bin"
  fish_add_path "$JAVA_HOME/bin"
end
