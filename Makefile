# you may need to disable McAfee content filter because it may blocks
# connection and artifact downloads from the maven central repository

SOURCES := $(shell find src/main/java/org/openmaptiles -name \*.java)
JAR := target/planetiler-openmaptiles-3.15.1-SNAPSHOT-with-deps.jar

$(JAR): $(SOURCES)
	MAVEN_OPTS="-DskipTests=true" ./mvnw clean package

.PRECIOUS: data/%.pmtiles
data/%.pmtiles: $(JAR)
	java -jar $(JAR) --force --osm-path=data/sources/$*.osm.pbf --output=data/$*.pmtiles

.PHONY: server-%
server-%: data/%.pmtiles
	ln -fs $*.pmtiles data/output.pmtiles
	tileserver-gl-light --config data/config.json

.PHONY: server
server: server-japan