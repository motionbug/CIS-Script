<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <computer_extension_attribute>
            <name>
                <xsl:value-of select="/extensionAttribute/displayName" />
            </name>
            <description>
                <xsl:value-of select="/extensionAttribute/description" />
            </description>
            <enabled>
                <xsl:value-of select="'true'" />
            </enabled>
            <data_type>
                <xsl:value-of select="/extensionAttribute/dataType" />
            </data_type>
            <input_type>
                <type>script</type>
                <platform>
                    <xsl:value-of select="'Mac'" />
                </platform>
                <script>
                    <xsl:value-of select="/extensionAttribute/scriptContentsMac" />
                </script>
            </input_type>
            <inventory_display>
                <xsl:value-of select="'Extension Attributes'" />
            </inventory_display>
        </computer_extension_attribute>
    </xsl:template>
</xsl:stylesheet>