{{- /*
Generate a fullname combining release name and chart name, e.g. "myrelease-wordpress"
*/ -}}
{{- define "wordpress-chart.fullname" -}}
{{ printf "%s-wordpress" .Release.Name }}
{{- end }}

{{- define "mysql.fullname" -}}
{{ printf "%s-mysql" .Release.Name }}
{{- end }}