<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:foo="http://www.nowhere.com/foo"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs foo saxon"
    version="2.0">
    
    <!-- this stylesheet was designed to do a one-time conversion of xml exported from the Butler Library inscriptions
        spreadsheet into basic EpiDoc XLM -->
    
    <xsl:param name="copyrightholders">Columbia University</xsl:param>
    
    <xsl:output method="xml" encoding="UTF-8" exclude-result-prefixes="#all" indent="yes"  name="epidoc" saxon:suppress-indentation="p"/>

    <xsl:variable name="newline">
        <xsl:text>
</xsl:text>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="foo:root">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="foo:row">

        <!-- ================================================================================= -->
        <!-- construct and output a TEI/EpiDoc file for this inscription -->
        <!-- ================================================================================= -->

        <xsl:variable name="foonum" select="lower-case(normalize-space(foo:Number))"/>
        <xsl:variable name="inum">
            <xsl:choose>
                <xsl:when test="$foonum='' or $foonum='n/a'">
                    <xsl:text>unnumbered-</xsl:text><xsl:value-of select="count(preceding::foo:Number[normalize-space(.)='' or lower-case(normalize-space(.))='n/a'])+1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(foo:Number)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="usepnum">
            <xsl:if test="not(contains($inum, 'unnumbered'))">
                <xsl:text>NY.NY.CU.Butl.L.</xsl:text><xsl:value-of select="$inum"/>
            </xsl:if>
        </xsl:variable> 
        <xsl:variable name="inscid">
            <xsl:text>icolbutler-</xsl:text><xsl:value-of select="$inum"/><xsl:text></xsl:text>
        </xsl:variable>
        <xsl:variable name="objname" select="lower-case(normalize-space(foo:Object_Name))"/>
        <xsl:message>objname: <xsl:value-of select="$objname"/></xsl:message>
        <xsl:variable name="mainlang">
            <xsl:choose>
                <xsl:when test="contains($objname, 'greek')">grc</xsl:when>
                <!-- test for greek characters in the text itself -->
                <xsl:otherwise>la</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:result-document format="epidoc" href="../xml/{$inscid}.xml">
            <xsl:processing-instruction name="xml-model">
                <xsl:text> href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng"</xsl:text> 
                <xsl:text> type="application/xml"</xsl:text>
                <xsl:value-of select="$newline"/>
                <xsl:text>   schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text></xsl:processing-instruction>
<xsl:text>
    
</xsl:text>
            <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title><xsl:value-of select="foo:Object_Name"/></title>
                            <xsl:comment>
                                <xsl:text> Use "editor" elements to list each of the editors of this text </xsl:text>
                            </xsl:comment>
                            <xsl:value-of select="$newline"/>
                            <xsl:text>         </xsl:text>
                        </titleStmt>                        
                        <publicationStmt>
                            <authority>Columbia University</authority>
                            <idno type="filename"><xsl:value-of select="$inscid"/></idno>
                            <xsl:if test="$usepnum!=''">
                                <idno type="USEpigraphy" xml:id="{$usepnum}"><xsl:value-of select="$usepnum"/></idno>
                            </xsl:if>
                            <xsl:value-of select="$newline"/>
                            <xsl:comment> add any other id numbers here </xsl:comment>
                            <xsl:value-of select="$newline"/>
                            <xsl:text>            </xsl:text><availability>
                                <licence target="http://creativecommons.org/licenses/by/3.0/">                                        
                                    <p>Copyright (c) 2012 by <xsl:value-of select="$copyrightholders"/></p>
                                    <p>This work is licensed under the Creative Commons Attribution 3.0 Unported,
                    License. To view a copy of this license, visit
                    http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
                    Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
                    USA.</p>
                                </licence>
                            </availability>
                        </publicationStmt>
                        <sourceDesc>
                            <msDesc>
                                <msIdentifier>
                                    <xsl:value-of select="$newline"/>
                                    <xsl:text>                  </xsl:text>
                                    <xsl:text></xsl:text>
                                    <xsl:comment>
                                        <xsl:text> this is how USEP constructs their own identifers; would Columbia prefer an </xsl:text>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                       internal system and construct USEP identifiers as "altIdentifier"? </xsl:text>
                                    </xsl:comment>
                                    <xsl:value-of select="$newline"/>
                                    <xsl:text>                  </xsl:text>
                                    <region>NY</region>
                                    <settlement>NY</settlement>
                                    <institution>CU</institution>
                                    <repository>Butl</repository>
                                    <idno><xsl:value-of select="$inum"/></idno>
                                    <xsl:comment><xsl:text> use altIdentifier elements, as appropriate, to provide information about other </xsl:text>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                       inventory numbers, past and present </xsl:text>
                                    </xsl:comment>
                                    <xsl:value-of select="$newline"/>
                                    <xsl:text>               </xsl:text>
                                </msIdentifier>
                                <msContents>
                                    <xsl:value-of select="$newline"/>
                                    <xsl:text>                  </xsl:text>
                                    <xsl:comment>
                                        <xsl:text>Describe the text, its disposition, and languages here </xsl:text>
                                    </xsl:comment>
                                    <xsl:value-of select="$newline"/>
                                    <xsl:text>                  </xsl:text>
                                    <textLang>
                                        <xsl:attribute name="mainLang" select="$mainlang"/>
                                    </textLang>
                                    <msItem>
                                        <!-- mine text classification, according to the USEP system in practice, out of the object name 
                                            (when possible) -->
                                        <xsl:variable name="class">
                                            <!-- possible values currently in use in USEP documents (determined by inspection):
                                                #verse
                                                #text_other
                                                #funerary.epitaph
                                                #stamp
                                                #text_unknown
                                                #commercial
                                                #label
                                                #magic.other
                                                #honorific.acclamation
                                                #dedicatory
                                                -->
                                            <!-- the tests below only address values I think I've seen in the spreadsheet data;
                                            they should not be regarded as comprehensive or reliable -->
                                            <xsl:if test="contains(replace($objname, 'reverse', ''), 'verse')">#verse<xsl:text> </xsl:text></xsl:if>
                                            <xsl:if test="contains($objname, 'tombstone') or contains($objname, 'epitaph')">#funerary.epitaph<xsl:text> </xsl:text></xsl:if>
                                            <xsl:if test="(contains($objname, 'columbarium') or contains($objname, 'funerary')) and not(contains($objname, 'epitaph'))">#funerary<xsl:text> </xsl:text></xsl:if>
                                            <xsl:if test="$objname='unknown'">#text_unknown<xsl:text> </xsl:text></xsl:if>
                                            <xsl:if test="contains($objname, 'calendar')">#calendar<xsl:text> </xsl:text></xsl:if>
                                        </xsl:variable>
                                        <xsl:attribute name="class" select="normalize-space($class)"/>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                     </xsl:text>
                                        <xsl:comment>
                                            <xsl:text> the value of the "class" attribute on the "msItem" element, as well as the </xsl:text>
                                            <xsl:value-of select="$newline"/>
                                            <xsl:text>                          </xsl:text>
                                            <xsl:text>content of the paragraph below have been mined from the original spreadsheet;</xsl:text>
                                            <xsl:value-of select="$newline"/>
                                            <xsl:text>                          </xsl:text>
                                            <xsl:text>they should be checked and adjusted for accuracy and completeness. Note that</xsl:text>
                                            <xsl:value-of select="$newline"/>
                                            <xsl:text>                          </xsl:text>
                                            <xsl:text>the paragraph content here should describe the text, not the text-bearing</xsl:text>
                                            <xsl:value-of select="$newline"/>
                                            <xsl:text>                          </xsl:text>
                                            <xsl:text>object (for the latter, see the "physDesc" element) </xsl:text>
                                        </xsl:comment>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                     </xsl:text>
                                        <p><xsl:value-of select="normalize-space(foo:Object_Name)"/></p>
                                    </msItem>
                                </msContents>
                                <physDesc>
                                    <objectDesc>
                                        <!-- mine object classification, according to the USEP system in practice, out of the object name 
                                            (when possible) -->
                                        <xsl:variable name="ana">
                                            <!-- possible values currently in use in USEP:
                                                #object_other
                                                #cippus
                                                #slab
                                                #stele
                                                #instrumentum.brick
                                                #instrumentum.other
                                                #sarcophagus
                                                #ash_urn
                                                #instrumentum.lamp
                                                #tablet
                                                #stele
                                                #sculpture
                                                #furniture
                                                #object_unknown
                                                #instrumentum.tessera
                                                #base
                                                #instrumentum.jewelry
                                                #arch_element
                                                #obj_Other
                                                #Instr_Dom
                                                #Instr_Dom.ornament
                                                #Instr_Dom.other_container
                                                #Instr_Dom.brick
                                                #altar
                                                #slab.tablet
                                                #Instr_Dom.tableware
                                                #Arch_element
                                                #Instr_Dom.vase
                                                #fragment
                                                #stele.cippus
                                                #statue_base
                                                #instrumentum.container.other
                                                #Instr_Dom.grooming_tool
                                                
                                                -->
                                            <!-- the tests below only address values I think I've seen in the spreadsheet data;
                                            they should not be regarded as comprehensive or reliable -->
                                            <!-- at present (2012-11-03) the tests below are not even complete for values in the spreadsheet -->
                                            <xsl:if test="contains($objname, 'fragment')">#fragment<xsl:text> </xsl:text></xsl:if>
                                            <xsl:if test="contains($objname, 'stele')">#stele<xsl:text> </xsl:text></xsl:if>
                                            <xsl:if test="contains($objname, 'slab')">#slab<xsl:text> </xsl:text></xsl:if>
                                            <xsl:if test="contains($objname, 'urn')">#ash_urn<xsl:text> </xsl:text></xsl:if>
                                            <xsl:if test="$objname='unknown'">#object_unknown<xsl:text> </xsl:text></xsl:if>
                                        </xsl:variable>
                                        <xsl:attribute name="ana" select="normalize-space($ana)"/>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                     </xsl:text>
                                        <xsl:comment> describe the text-bearing object, its condition and history here </xsl:comment>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                     </xsl:text>
                                        <supportDesc>
                                            <support>
                                                <xsl:value-of select="$newline"/>
                                                <xsl:text>                           </xsl:text>
                                                <xsl:comment>
                                                    <xsl:text > Current USEP documents do not seem to use the "objectType" or "material"</xsl:text>
                                                    <xsl:value-of select="$newline"/>
                                                    <xsl:text>                                </xsl:text>
                                                    <xsl:text>elements; rather, they use seg@type=material and seg@type=form; need to</xsl:text>
                                                    <xsl:value-of select="$newline"/>
                                                    <xsl:text>                                </xsl:text>
                                                    <xsl:text>check with USEP about this </xsl:text>
                                                </xsl:comment>
                                                <xsl:if test="normalize-space($ana) = '' or normalize-space($ana) = ' '">
                                                    <xsl:value-of select="$newline"/>
                                                    <xsl:text>                           </xsl:text>
                                                    <xsl:comment>
                                                        <xsl:text> Unable to parse values for the "ana" attribute on the "objectDesc"</xsl:text>
                                                        <xsl:value-of select="$newline"/>
                                                        <xsl:text>                               </xsl:text>
                                                        <xsl:text> nor for the "objectType" element to be included in the paragraph</xsl:text>
                                                        <xsl:value-of select="$newline"/>
                                                        <xsl:text>                               </xsl:text>
                                                        <xsl:text> below. These will need to be added manually.</xsl:text>
                                                    </xsl:comment>
                                                </xsl:if>
                                                <xsl:value-of select="$newline"/>
                                                <xsl:text>                           </xsl:text>
                                                <p><xsl:text></xsl:text>
                                                    <xsl:choose>
                                                        <xsl:when test="normalize-space($ana) = '' or normalize-space($ana) = ' '"/>
                                                        <xsl:otherwise>
                                                            <xsl:for-each select="tokenize($ana, ' ')">
                                                                <objectType>
                                                                    <xsl:value-of select="normalize-space(replace(replace(., '#', ''), '_', ' '))"/>
                                                                </objectType><xsl:text>; </xsl:text>
                                                            </xsl:for-each>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                              <xsl:text></xsl:text><material><xsl:value-of select="foo:Medium"/></material><xsl:text>; </xsl:text>
                              <xsl:value-of select="$newline"/>
                              <xsl:text>                              </xsl:text>
                              <dimensions type="" unit="cm">
                                  <xsl:variable name="dimbits" select="tokenize(foo:Measurements_in_cm._width_x_height__x_depth_where_recorded_, 'x')"/>
                                  <xsl:message>size of dimbits <xsl:value-of select="count($dimbits)"/></xsl:message>
                                  <xsl:variable name="dimx" >
                                      <xsl:if test="count($dimbits) &gt; 0">
                                          <xsl:value-of select="normalize-space($dimbits[1])"/>
                                      </xsl:if>
                                  </xsl:variable>
                                  <xsl:variable name="dimy">
                                      <xsl:if test="count($dimbits) &gt; 1">
                                          <xsl:value-of select="normalize-space($dimbits[2])"/>
                                      </xsl:if>                                      
                                  </xsl:variable>
                                  <xsl:variable name="dimz">
                                      <xsl:if test="count($dimbits) &gt; 2">
                                          <xsl:value-of select="normalize-space($dimbits[3])"/>
                                      </xsl:if>                                      
                                  </xsl:variable>
                                  <xsl:variable name="dimother">
                                      <xsl:if test="count($dimbits) &gt; 3">
                                          <xsl:value-of select="normalize-space($dimbits[4])"/>
                                      </xsl:if>
                                  </xsl:variable>
                                  <xsl:choose>
                                      <xsl:when test="not(contains($dimx, ' ')) and not(contains($dimy, ' ')) and not(contains($dimz, ' '))">
                                          <xsl:value-of select="$newline"/>
                                          <xsl:text>                                 </xsl:text>
                                          <xsl:comment> original string: "<xsl:value-of select="foo:Measurements_in_cm._width_x_height__x_depth_where_recorded_"/>"</xsl:comment>
                                          <xsl:if test="$dimx!=''">
                                              <xsl:value-of select="$newline"/>
                                              <xsl:text>                                 </xsl:text>
                                              <width><xsl:value-of select="$dimx"/></width>
                                          </xsl:if>
                                          <xsl:if test="$dimy!=''">
                                              <xsl:value-of select="$newline"/>
                                              <xsl:text>                                 </xsl:text>
                                              <height><xsl:value-of select="$dimy"/></height>
                                          </xsl:if>
                                          <xsl:if test="$dimz!=''">
                                              <xsl:value-of select="$newline"/>
                                              <xsl:text>                                 </xsl:text>
                                              <depth><xsl:value-of select="$dimz"/></depth>
                                          </xsl:if>                                          
                                      </xsl:when>
                                      <xsl:otherwise>
                                          <xsl:value-of select="$newline"/>
                                          <xsl:text>                                 </xsl:text>
                                          <xsl:comment>
                                              <xsl:text> Could not successfully parse the following string into simple "height",</xsl:text>
                                              <xsl:value-of select="$newline"/>
                                              <xsl:text>                                      </xsl:text>
                                              <xsl:text>width, and depth values:</xsl:text> 
                                              <xsl:value-of select="$newline"/>
                                              <xsl:value-of select="$newline"/>
                                              <xsl:text>                                      </xsl:text>
                                              <xsl:text>"</xsl:text>
                                              <xsl:value-of select="foo:Measurements_in_cm._width_x_height__x_depth_where_recorded_"/>
                                              <xsl:text>"</xsl:text>
                                            <xsl:value-of select="$newline"/>
                                          <xsl:value-of select="$newline"/>
                                          <xsl:text>                                 </xsl:text>
                                          </xsl:comment>
                                      </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:value-of select="$newline"/>
                                  <xsl:text>                              </xsl:text>
                              </dimensions>.</p>                        
                                            </support>
                                            <condition>
                                                <xsl:variable name="ana">
                                                    <!-- possible values currently in use in USEP:
                                                        #complete
                                                        #complete.broken
                                                        #complete.intact
                                                        #fragment
                                                        #fragment.single
                                                        #fragments.contig
                                                        -->
                                                    <xsl:if test="contains($objname, 'fragment')">#fragment<xsl:text> </xsl:text></xsl:if>
                                                </xsl:variable>
                                                <xsl:attribute name="ana" select="normalize-space($ana)"/>
                                                <xsl:value-of select="$newline"/>
                                                <xsl:text>                           </xsl:text>
                                                <xsl:comment>provide appropriate values for the "ana" attribute from the USEP vocabulary</xsl:comment>
                                                <xsl:value-of select="$newline"/>
                                                <xsl:text>                           </xsl:text>
                                                <p><xsl:comment>Use free text to describe the condition of the support</xsl:comment></p>
                                            </condition>
                                        </supportDesc>
                                        <layoutDesc>
                                            <layout>
                                                <xsl:attribute name="columns"></xsl:attribute>
                                                <xsl:attribute name="writtenLines" select="count(tokenize(foo:Transcription, '/'))"/>
                                                <xsl:value-of select="$newline"/>
                                                <xsl:text>                           </xsl:text>
                                                <p><xsl:comment>Use free text to describe the layout of the text on the support</xsl:comment></p>
                                            </layout>
                                        </layoutDesc>
                                    </objectDesc>
                                    <handDesc ana="">
                                        <handNote></handNote>
                                    </handDesc>
                                    <decoDesc>
                                        <decoNote ana="">
                                            <p></p>
                                        </decoNote>
                                    </decoDesc>
                                </physDesc>
                                <history>
                                    <summary>
                                        <xsl:comment>
                                            <xsl:text>use this section to summarize the history of the object </xsl:text>
                                        </xsl:comment>
                                    </summary>
                                    <origin>
                                        <origPlace type="location"><xsl:value-of select="foo:Provenance"/></origPlace>
                                        <origDate notBefore="" notAfter=""><xsl:value-of select="foo:Suggested_date"/></origDate>
                                    </origin>
                                    <xsl:comment>
                                        <xsl:text>add "provenance" elements as needed to express other key events in the modern history</xsl:text>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                      </xsl:text>
                                        <xsl:text>of this object</xsl:text>
                                    </xsl:comment>
                                    <xsl:value-of select="$newline"/>
                                    <xsl:text>                  </xsl:text>
                                    <provenance type="observed" notAfter="2012-10-19">
                                        <ab>Identified in the Butler library collection not later than 19 October 2012.</ab>
                                    </provenance>
                                </history>
                                <additional>
                                    <surrogates>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                     </xsl:text>
                                        <xsl:comment>
                                            <xsl:text>information about squeezes, photos, notebooks, and other unpublished material</xsl:text>
                                            <xsl:value-of select="$newline"/>
                                            <xsl:text>                         </xsl:text>
                                            <xsl:text>goes here</xsl:text>
                                        </xsl:comment>
                                        <xsl:value-of select="$newline"/>
                                        <xsl:text>                  </xsl:text>
                                    </surrogates>
                                </additional>
                            </msDesc>
                            <listBibl>
                                <xsl:choose>
                                    <xsl:when test="normalize-space(lower-case(foo:Publication)) = 'unpublished'">
                                        <xsl:comment>unpublished inscription</xsl:comment>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="tokenize(foo:Publication, ';')">
                                            <bibl><xsl:value-of select="normalize-space(.)"/></bibl>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </listBibl>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <xi:include href="http://dev.stg.brown.edu/projects/usepigraphy/xml/include_taxonomies.xml">
                            <xi:fallback>
                                <p>Taxonomies for US Epigraphy controlled values</p>
                            </xi:fallback>
                        </xi:include>
                    </encodingDesc>
                    <revisionDesc>
                        <change when="{current-dateTime()}" who="TRE">programmatically converted from inital spreadsheet</change>
                    </revisionDesc>
                </teiHeader>
                <facsimile>
                    <xsl:value-of select="$newline"/>
                    <xsl:text>       </xsl:text>
                    <xsl:comment>
                        <xsl:text> Information about digital images and other digital documents that should go with this</xsl:text>
                        <xsl:value-of select="$newline"/>
                        <xsl:text>            </xsl:text>
                        <xsl:text>document should be encoded here.</xsl:text>
                    </xsl:comment>
                    <xsl:value-of select="$newline"/>
                    <xsl:text>    </xsl:text>
                </facsimile>
                <text>
                    <body>
                        <div type="edition" xml:lang="{$mainlang}">
                            <xsl:attribute name="xml:space">preserve</xsl:attribute>
                            <xsl:value-of select="$newline"/>
                            <xsl:text>            </xsl:text>
                            <xsl:comment>
                                <xsl:text> The content of this "div" element is not (as of </xsl:text><xsl:value-of select="current-date()"/><xsl:text>) conformant</xsl:text>
                                <xsl:value-of select="$newline"/>
                                <xsl:text>                 </xsl:text>
                                <xsl:text>EpiDoc. It is simply text that has been copied, leiden siglan and all, into this</xsl:text>
                                <xsl:value-of select="$newline"/>
                                <xsl:text>                 </xsl:text>
                                <xsl:text>document from the initial spreadsheet. It will need to be converted into proper</xsl:text>
                                <xsl:value-of select="$newline"/>
                                <xsl:text>                 </xsl:text>
                                <xsl:text>EpiDoc encoding.</xsl:text>
                            </xsl:comment>
                            <xsl:value-of select="$newline"/>
                            <xsl:text>            </xsl:text>
                            <ab>
                                <xsl:value-of select="foo:Transcription"/>
                            </ab>
                            <xsl:value-of select="$newline"/>
                            <xsl:text>         </xsl:text>
                        </div>
                        <div type="translation" xml:lang="en">
                            <ab>
                                <xsl:value-of select="foo:Translation"/>
                            </ab>
                        </div>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    
    
</xsl:stylesheet>