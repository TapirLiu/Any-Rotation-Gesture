package com.tapirgames.gesture {
   
   public class GesturePoint
   {
      public var mPrevPoint:GesturePoint = null;
      public var mNextPoint:GesturePoint = null;
      
      public var mIndex:int;
      public var mDistanceValuesFromIndex:int;

      public var mX:Number;
      public var mY:Number;
      public var mTime:Number;
      
      public var mAccumulatedLength:Number;
      
      public function GesturePoint (x:Number, y:Number, time:Number)
      {
         mX = x;
         mY = y;
         mTime = time;
      }
   }
}
