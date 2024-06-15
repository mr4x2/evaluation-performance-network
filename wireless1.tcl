#Asimpleexampleforwirelesssimulation

#======================================================================
#Defineoptions
#======================================================================
setval(chan)	Channel/WirelessChannel	;#channeltype
setval(prop)	Propagation/TwoRayGround;#radio-propagationmodel
setval(netif)	Phy/WirelessPhy		;#networkinterfacetype
setval(mac)	Mac/802_11		;#MACtype
setval(ifq)	Queue/DropTail/PriQueue	;#Interfacequeuetype
setval(ll)	LL			;#Linklayertype
setval(ant)	Antenna/OmniAntenna	;#Antennatype
setval(x)	670	;#Xdimensionofthetopography
setval(y)	670	;#Ydimensionofthetopography
setval(ifqlen)	50	;#maxpacketinifq
setval(seed)	0.0		;#randomseed
setval(adhocRouting)	AODV	;#AODV/DSDV/TORA...
setval(nn)64	;#howmanynodesaresimulated
#setval(cp)	"../mobility/scene/cbr-3-test"
setval(cp)	"./cbr-3-test"		;#cp=connectionpattern
#setval(sc)	"../mobility/scene/scen-3-test"
setval(sc)	"./20021460.txt"		;#sc=scenario=movementpattern
setval(stop)	400.0			;#simulationtime

#=====================================================================
#MainProgram
#======================================================================
#
#InitializeGlobalVariables
#
#createsimulatorinstance
setns_		[newSimulator]

#setuptopographyobject
settopo	[newTopography]

#createtraceobjectfornsandnam
settracefd	[openwireless1-out.trw]
setnamtrace[openwireless1-out.namw]

$ns_trace-all$tracefd
$ns_namtrace-all-wireless$namtrace$val(x)$val(y)

#definetopology
$topoload_flatgrid$val(x)$val(y)

#CreateogjectGod(GeneralOperationsDirector)
#thatstoresthetotalnumberofmobilenodesandatableofshortest
#numberofhopsrequiredtoreachfromonenodetoanother.++
setgod_[create-god$val(nn)]

#definehownodeshouldbecreated
#

#globalnodesetting(configuring)
$ns_node-config-adhocRouting$val(adhocRouting)\
-llType$val(ll)\
-macType$val(mac)\
-ifqType$val(ifq)\
-ifqLen$val(ifqlen)\
-antType$val(ant)\
-propType$val(prop)\
-phyType$val(netif)\
-channelType$val(chan)\
		-topoInstance$topo\
		-agentTraceON\
-routerTraceON\
-macTraceON


#Createthespecifiednumberofnodes[$val(nn)]and"attach"them
#tothechannel.
for{seti0}{$i<$val(nn)}{incri}{
	setnode_($i)[$ns_node]	
	$node_($i)random-motion0	;#disablerandommotion
}

#Definenodemovementmodel
puts"Loadingconnectionpattern..."
source$val(cp)			;#Loadandruncodesspecifiedby$val(cp)

#Definetrafficmodel
puts"Loadingscenariofile..."
source$val(sc)			;#Loadandruncodesspecifiedby$val(sc)

#Definenodeinitialsizeinnam
for{seti0}{$i<$val(nn)}{incri}{
$ns_initial_node_pos$node_($i)20
#20definesthenodesizebutnodepositioninnam,
#mustadjustitaccordingtoyourscenario.
#Thefunctionmustbecalledaftermobilitymodelisdefined
}

#Tellnodeswhenthesimulationends
for{seti0}{$i<$val(nn)}{incri}{
$ns_at$val(stop).0"$node_($i)reset";
}

$ns_at$val(stop).0002"puts\"NSEXITING...\";$ns_halt"
puts$tracefd"M0.0nn$val(nn)x$val(x)y$val(y)rp$val(adhocRouting)"
puts$tracefd"M0.0sc$val(sc)cp$val(cp)seed$val(seed)"
puts$tracefd"M0.0prop$val(prop)ant$val(ant)"

puts"StartingSimulation..."
$ns_run

