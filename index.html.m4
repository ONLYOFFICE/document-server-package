<html>
    <body>
ifdef(`M4_DEB_URI',
`        <p>Debian 8 9, Ubuntu 14.04 16.04 18.04 and derivatives
            <a href="https://M4_S3_BUCKET.s3-eu-west-1.amazonaws.com/M4_DEB_URI">deb</a>
        </p>',)
ifdef(`M4_RPM_URI',
`        <p>Centos 7, Redhat 7, Fedora latest and derivatives
            <a href="https://M4_S3_BUCKET.s3-eu-west-1.amazonaws.com/M4_RPM_URI">rpm</a>
        </p>',)
ifdef(`M4_APT_RPM_URI',
`        <p>Altlinux p8
            <a href="https://M4_S3_BUCKET.s3-eu-west-1.amazonaws.com/M4_APT_RPM_URI">rpm</a>
        </p>',)
ifdef(`M4_EXE_URI',
`        <p>Windows
            <a href="https://M4_S3_BUCKET.s3-eu-west-1.amazonaws.com/M4_EXE_URI">exe</a>
        </p>',)
    </body>
</html>