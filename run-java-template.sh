##set coredump directory, run it manually
#ulimit -c unlimited
#echo "/{MYLOGDIR}/coredump.%p" > /proc/sys/kernel/core_pattern

##jvm opt
JVM_LOG_OPT=-XX:+PrintCommandLineFlags -XX:+PrintCommandLineFlags -XX:+PrintGCCaus -XX:+PrintPromotionFailure
##jvm opt2, works with java7/8, incompatible with java9
JVM_LOG_OPT2=-Xloggc:/dev/shm/gc-myapp.log -XX:+PrintGCDateStamps -XX:+PrintGCDetails

##safe point
SAFE_POINT=-XX:+PrintSafepointStatistics -XX: PrintSafepointStatisticsCount=1 -XX:+UnlockDiagnosticVMOptions \
-XX:- DisplayVMOutput -XX:+LogVMOutput -XX:LogFile=/dev/shm/vm-myapp.log

## for heavy io system
IO_OPTIMIZE=-XX:MaxTenuringThreshold=2 

## jmx
JMX_OPT=-Dcom.sun.management.jmxremote.port=7001 -Dcom.sun.management.jmxremote \ 
-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false \
-Djava.rmi.server.hostname=127.0.0.1

## cms gc
GC_OPT=-XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly \
-XX:+ExplicitGCInvokesConcurrent \
-XX:+UnlockDiagnosticVMOptions -XX: ParGCCardsPerStrideChunk=1024 \
-Xmx4G -Xms6G -XX:NewRatio=1 \
-XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m

## gc2, change it base on your cpu number
GC_OPT2=-XX:ParallelGCThreads=18 =XX:ConcGCThreads=5 -XX:－CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark \
-Xss1M \  # default 1M, base on your system
-XX:SurvivorRatio=10 \ # this means eden:survivor=2:10, default=8
-XX:MaxDirectMemorySize=1G \ # default = heap size - 1 survivor size
-XX:ReservedCodeCacheSize=256M \ # for jit codes, default 240M in java8

## performance, TODO
PERFORMANCE_OPT=

java -jar X.jar $JVM_LOG_OPT $JVM_LOG_OPT2 $IO_OPTIMIZE $JMX_OPT $GC_OPT $GC_OPT2 $PERFORMANCE_OPT
