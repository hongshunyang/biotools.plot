#!/usr/bin/env Rscript



f1="./sheet1.csv";
f2="./sheet2.csv";
f3="./sheet3.csv";

res1 = read.csv(f1, sep=',',header=TRUE);
res2 = read.csv(f2, sep=',',header=TRUE);
res3 = read.csv(f3, sep=',',header=TRUE);

img_xlab = "log2(fold_change)";
img_ylab = "-log10(p.Value)";

p1="./image1.pdf";
p2="./image2.pdf";
p3="./image3.pdf";
p4="./image4.pdf";
p5="./image5.pdf";

pdf(p1,width=60,height=40);
par(mai=c(5,5,5,5),mgp=c(3, 3, 0));
with(res1,plot(fold_change,-log10(p.Value),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""));
with(res2,points(fold_change,-log10(p.Value),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab="",col="red"));
mtext('black dots of sheet1 red dots of sheet2',side=3,line=8,cex=6);
mtext(img_xlab,side=1,line=8,cex=6);
mtext(img_ylab,side=2,line=8,cex=6);
dev.off();

pdf(p2,width=60,height=40);
par(mai=c(5,5,5,5),mgp=c(3, 3, 0));
with(res3,plot(fold_change,-log10(p.Value),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab="",col="green"));
mtext('green dots of sheet3',side=3,line=8,cex=6);
mtext(img_xlab,side=1,line=8,cex=6);
mtext(img_ylab,side=2,line=8,cex=6);
dev.off();

pdf(p3,width=60,height=40);
par(mai=c(5,5,5,5),mgp=c(3, 3, 0));
with(res1,plot(fold_change,-log10(p.Value),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""));
with(res2,points(fold_change,-log10(p.Value),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab="",col="red"));
with(res3,points(fold_change,-log10(p.Value),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab="",col="green"));
mtext('black dots of sheet1,red dots of sheet2 ,green dots of sheet3',side=3,line=8,cex=6);
mtext(img_xlab,side=1,line=8,cex=6);
mtext(img_ylab,side=2,line=8,cex=6);
dev.off();

pdf(p4,width=60,height=40);
par(mai=c(5,5,5,5),mgp=c(3, 3, 0));
with(res2,plot(fold_change,-log10(p.Value),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab="",col="red"));
mtext('red dots of sheet2',side=3,line=8,cex=6);
mtext(img_xlab,side=1,line=8,cex=6);
mtext(img_ylab,side=2,line=8,cex=6);
dev.off();


pdf(p5,width=60,height=40);
par(mai=c(5,5,5,5),mgp=c(3, 3, 0));
with(res1,plot(fold_change,-log10(p.Value),pch=19,cex=2,cex.axis=4,main="",xlab="",ylab=""));
mtext('black dots of sheet1',side=3,line=8,cex=6);
mtext(img_xlab,side=1,line=8,cex=6);
mtext(img_ylab,side=2,line=8,cex=6);
dev.off();





