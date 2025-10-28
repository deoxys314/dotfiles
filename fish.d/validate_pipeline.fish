function validate_pipeline --description 'Use jenkins server to validate a pipeline is semantically correct' --argument-names pipeline_file
	if test -z "$JENKINS_AUTH"
		echo '$JENKINS_AUTH must be set'
		exit 1
	end
	if test -z "$JENKINS_URL"
		echo '$JENINS_URL must be set'
		exit 1
	end
	curl -X POST --user "$JENKINS_AUTH" \
		-F (printf 'jenkinsfile=<%s' $pipeline_file) \
		"$JENKINS_URL/pipeline-model-converter/validate"
end
