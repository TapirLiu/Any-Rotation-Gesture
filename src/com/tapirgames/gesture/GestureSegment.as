package com.tapirgames.gesture {
   
   public class GestureSegment
   {
      public var mPrevSegment:GestureSegment = null;
      public var mNextSegment:GestureSegment = null;
      
      public var mStartPoint:GesturePoint;
      public var mEndPoint:GesturePoint;
      
      public var mIndex:int;

      public var mDx:Number;
      public var mDy:Number;
      //public var mStartEndDistance:Number;
      //public var mAccumulatedLength:Number;
      //public var mStartEndDistanceToAccumulatedLengthRatio:Number;
      
      public var mDeltaAngle:Number = 0; // relative to prev line. For first line, it is always 0
      public var mAccumulatedAngle:Number = 0; // for first line, it is always 0
      
      public function GestureSegment (startPoint:GesturePoint, endPoint:GesturePoint)
      {
         mStartPoint = startPoint;
         mEndPoint = endPoint;
      }
   }
}
