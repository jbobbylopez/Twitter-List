<map version="freeplane 1.2.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Twitter::List::Create::CPANAuthors" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1376335672832"><hook NAME="MapStyle">

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node">
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right">
<stylenode LOCALIZED_TEXT="default" MAX_WIDTH="600" COLOR="#000000" STYLE="as_parent">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.note"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="7"/>
<font ITALIC="false"/>
<node TEXT="What is it?" POSITION="right" ID="ID_96604297" CREATED="1376312409817" MODIFIED="1376312472182">
<edge COLOR="#0000ff"/>
<node TEXT="A tool that generates a list of CPAN authors with twitter acounts, then converts this list into a twitter list on the connected twitter account." ID="ID_1223937254" CREATED="1376312474898" MODIFIED="1376312586008"/>
</node>
<node TEXT="How does it do it?" POSITION="right" ID="ID_1404114213" CREATED="1376312590146" MODIFIED="1376312594324">
<edge COLOR="#ff00ff"/>
<node TEXT="Gather list of CPAN authors with twitter accounts from MetaCPAN via API" ID="ID_1374384661" CREATED="1376312599004" MODIFIED="1376312620106"/>
<node TEXT="Create a Twitter application key for the demo application." ID="ID_1173255509" CREATED="1376312622365" MODIFIED="1376312680546"/>
<node TEXT="Use Net::Twitter tools to create and populate list" ID="ID_1749331981" CREATED="1376312681257" MODIFIED="1376312696788"/>
</node>
<node TEXT="Use Cases" POSITION="right" ID="ID_361301067" CREATED="1376312917344" MODIFIED="1376312920689">
<edge COLOR="#00ffff"/>
<node TEXT="MetaCPAN generates list of CPAN Authors, and publishes Twitter list, which can be subscribed to." ID="ID_462548124" CREATED="1376312926703" MODIFIED="1376312957992"/>
<node TEXT="Twitter users can generate their own lists" ID="ID_1752101273" CREATED="1376312958962" MODIFIED="1376313009125"/>
</node>
<node TEXT="Under-the-hood" POSITION="right" ID="ID_248781607" CREATED="1376313026278" MODIFIED="1376313070390">
<edge COLOR="#ffff00"/>
<node TEXT="List is cached, and updated frequently (via cron)" ID="ID_1872482460" CREATED="1376313072121" MODIFIED="1376313094246"/>
<node TEXT="TPM Twitter list is kept up-to-date" ID="ID_1560054047" CREATED="1376313096140" MODIFIED="1376313110954"/>
<node TEXT="Users twitter lists can be updated on demand" ID="ID_112382969" CREATED="1376313111451" MODIFIED="1376313146082"/>
</node>
<node TEXT="Module Dependencies" POSITION="right" ID="ID_493787993" CREATED="1376321734663" MODIFIED="1376321739861">
<edge COLOR="#7c0000"/>
<node TEXT="Net::Twitter" ID="ID_942997025" CREATED="1376321903745" MODIFIED="1376321906230"/>
<node TEXT="ElasticSearch" ID="ID_1110044570" CREATED="1376321763081" MODIFIED="1376321784516"/>
</node>
</node>
</map>
